# Command behaviors set here...

function _set_host_port() {
  export $1_HOST=$2
  export $1_PORT=$3
}

function _get_origins() {
  echo "MOVIE_ORIGIN   = $MOVIE_HOST:$MOVIE_PORT"
  echo "STATICS_ORIGIN = $STATICS_HOST:$STATICS_PORT"
}

function _set_movie() {
  _set_host_port MOVIE $1 $2
}

function _set_statics() {
  _set_host_port STATICS $1 $2
}

function _set_origins_host() {
  _set_movie $1 $MOVIE_PORT
  _set_statics $1 $STATICS_PORT
}

function _set_origins_router_host() {
  _set_origins_host "192.168.0.100"
}

function _detect_wlan0_ip() {
  local myip=$(ip -4 -o addr show wlan0 | tr / \ | awk '{ print $4 }')
  [[ -z $myip ]] && echo 127.0.0.1 || echo $myip
}

function _set_current_ip() {
  _set_origins_host $(_detect_wlan0_ip)
}

function _set_origins_local_host() {
  _set_origins_host localhost
}

function shlvl_() {
  echo "Shell LEVEL: $SHLVL"
}

function _get_virtual_env() {
  [[ -d "$VIRTUAL_ENV" ]] && echo -n "$(basename "$VIRTUAL_ENV") "
}

function _get_state_char() {
  # symbols="✓×"
  # [[ $_LAST_COMMAND_STATE -eq 0 ]] && echo -n '✓' || echo -n '×'
  [[ $_LAST_COMMAND_STATE -eq 0 ]] && echo -n $'\u2714' || echo -n $'\u2718'
}

function _get_state_color() {
  local OK_COLOR='\e[37;1m'
  local ERR_COLOR='\e[31;1m'
  # symbols="✓×"
  [[ $_LAST_COMMAND_STATE -eq 0 ]] && echo -en "$OK_COLOR" || echo -en "$ERR_COLOR"
}

function _set_last_command_state() {
  _LAST_COMMAND_STATE=$?
  return $_LAST_COMMAND_STATE
}

_LAST_COMMAND_STATE=0
PROMPT_COMMAND=_set_last_command_state
PS1=$'\[\e[97;1m\]$(_get_virtual_env)\[\e[96;1m\]\W \[$(_get_state_color)\]• \[\e[0m\]'

function _get_venvs_completion() {
  local curr_word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD - 1]}"
  COMPREPLY=($(compgen -W "$(ls "$CONTENT_VENVS")" -- $curr_word))
}

function _get_venvs_drop() {
  _get_venvs_completion
}

function _get_venv_activate_completion() {
  if [ "$COMP_CWORD" -lt 2 ]; then
    _get_venvs_completion
  else
    COMPREPLY=()
  fi
}

function _activate_venv() {
  local venv_path=
  if [ -z "$1" ]; then
    venv_path="$DEF_PYTHON_ENV"
  else
    venv_path="$CONTENT_VENVS/$1"
  fi
  if [ ! -d "$venv_path" ]; then
    echo Invalid Venv: $(basename $venv_path) >/dev/stderr
    return 2
  fi
  source "$venv_path/bin/activate"
}

function _create_venv() {
  if [ -z "$1" ]; then
    echo Must Provide Venv Name. >/dev/stderr
    return 1
  fi
  local venv_path="$CONTENT_VENVS/$1"
  if [ -e "$venv_path" ]; then
    echo Venv Already exists: $venv_path >/dev/stderr
    return 1
  fi
  virtualenv "$venv_path"
}

function _list_venvs() {
  ls "$CONTENT_VENVS"
}

function _update_venvs() {
  local current_venv="$VIRTUAL_ENV"
  for venv in `_list_venvs`; do
    _activate_venv "$venv" && {
      pip install -U $(pip list | sed 1,2d | awk '{print $1}')
      deactivate
    }
  done
  if [ -n "$current_venv" ]; then
    _activate_venv "$(basename "$current_venv")"
  fi
}

function _load_venv_requrements() {
  local outputdir="$1"
  if [ -z "$outputdir" ]; then
    outputdir=./requirements
  fi
  if [ ! -e "$outputdir" ]; then
    mkdir "$outputdir"
  elif [ ! -d "$outputdir" ]; then
    echo Invalid OutputPath: $outputdir >/dev/stderr
    return 2
  fi
  local current_venv="$(basename "$VIRTUAL_ENV")"
  while read venv; do
    _activate_venv "$venv"
    pip list --format=freeze >"$outputdir/$venv"
  done <<<$(ls "$CONTENT_VENVS")
  if [ ! -z "$current_venv" ]; then
    _activate_venv "$current_venv"
  fi
}

function _drop_venv() {
  local venv_path
  for venv; do
    venv_path="$CONTENT_VENVS/$venv"
    if [ -e "$venv_path" ]; then
      read -p "Delete Venv: '$venv'?[Y/n] " confirmation
      if [ "$confirmation" == 'y' ] || [ "$confirmation" == 'Y' ]; then
        if [ "$venv" == "$(basename "$DEF_PYTHON_ENV")" ]; then
          read -p "This is the default venv, confirm delete?[Y/n] " confirmation
          if [ "$confirmation" != 'y' ] || [ "$confirmation" != 'Y' ]; then
            continue
          fi
        fi
        rm -rf "$venv_path"
      fi
    else
      echo VenvNotFound: $venv_path >/dev/stderr
      return 2
    fi
  done
}

function _encfs_vault_mounted() {
  # [ "$(df --output=source "$VAULT_MOUNT_POINT" | sed 1d)" == encfs ]
  mountpoint -q "$VAULT_MOUNT_POINT"
}

function _setup_encfs_vault() {
  encfs "$ENCRYPTED_VAULT_DIR" "$VAULT_MOUNT_POINT"
}

function _mount_encfs_vault() {
  if _encfs_vault_mounted; then
    echo Vault Already Mounted >/dev/stderr
    return 1
  else
    chmod 755 "$VAULT_MOUNT_POINT"
    encfs "$ENCRYPTED_VAULT_DIR" "$VAULT_MOUNT_POINT" -o auto_unmount
  fi
}

function _unmount_encfs_vault() {
  if [ "$1" == '-h' ]; then
    echo '-h print this help and exit'
    echo '-f force unmount'
    return 0
  fi
  if _encfs_vault_mounted; then
    if [ "$1" == '-f' ]; then
      umount -l "$VAULT_MOUNT_POINT"
    else
      fusermount -u "$VAULT_MOUNT_POINT"
    fi
    chmod 555 "$VAULT_MOUNT_POINT"
  else
    echo Vault Not Mounted >/dev/stderr
    return 1
  fi
}

function _start_ssh_agent_daemon() {
  local ssh_agent_pid=$(pgrep ssh-agent)
  if [ -z "$ssh_agent_pid" ] || [ "-f" == "$1" ]; then
    [ "-f" == "$1" ] && pkill ssh-agent
    eval $(ssh-agent -s)
  else
    echo ssh-agent already running on PID: $ssh_agent_pid >&2
    return 1
  fi
}

function _ssh_add_key() {
  local key="$1"
  local keypath="$HOME/.ssh/keys/$key"
  if [ ! -f "$keypath" ]; then
    echo Key Not Found: $keypath >/dev/stderr
    return 2
  fi
  ssh-add "$keypath"
}

function _expand_alias() {
  if [ $# -ne 1 ]; then
    echo "Usage: expand_alias <alias_name>" >&2
    return 2
  fi
  { echo "${BASH_ALIASES["$1"]?}" || return $?; } 2>/dev/null
}

function _total_commits() {
  for project in $CONTENT_ETC/repos/*; do
    git 2>/dev/null -C "$project" log \
      --author="Simon Nganga" \
      --format="%an"
    echo
  done | wc -l
}

function _mwifi_setup() {
  if ! _encfs_vault_mounted; then
    echo >&2 "Vault not mounted"
    return 1
  fi
  _set_current_ip
  echo "Activating VENV: movie-app"
  _activate_venv movie-app
  echo "SERVING AT:"
  echo "  MOVIE:"
  echo "    HOST=$MOVIE_HOST"
  echo "    PORT=$MOVIE_PORT"
  echo "  STATICS:"
  echo "    HOST=$STATICS_HOST"
  echo "    PORT=$STATICS_PORT"
  echo "Starting SERVER"
  movie-app
  echo Shutting DOWN: movie-app
  deactivate
}

function _explain_exit_status() {
  perror $?
}

