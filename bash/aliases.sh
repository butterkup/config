# My aliases: Must find behaviors before setting aliases

alias origins_router="_set_origins_router_host"
alias origins_local="_set_origins_local_host"
alias origins="_get_origins"
alias wlan0_origins="_set_current_ip"
alias movie_origin="_set_movie"
alias statics_origin="_set_statics"
alias py3=python3
alias python=python3
alias ipy=ipython3
alias ipython=ipython3
alias mwifi-load='python "$CONTENT_CODE/live/python/movie-app-2/preload.py"'

alias clr=clear
alias statics="run -C $CONTENT_CODE/live/python/statics"
alias shut="shutdown --poweroff now"
alias boot="shutdown --reboot now"
alias sql="sqlite3 --box"
# alias wifi_movie="origins_router && no_watch"
# alias wifi_load_movie="origins_router && watch_movie load"
alias mwifi="_mwifi_setup"

alias nameep="python3 -m mpack.nameep"
# alias inpm="npm --no-fund --no-audit --no-install-links"
alias mtools="python3 -m mpack.cmd_tools"

alias ..="cd ../"
alias '_'="cd -"
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias activate=_activate_venv
alias createvenv=_create_venv
alias lsvenv=_list_venvs
alias loadvenvrq=_load_venv_requrements
alias dropvenv=_drop_venv
alias updatevenvs=_update_venvs
complete -F _get_venv_activate_completion activate
complete -F _get_venvs_drop dropvenv

alias vstp=_setup_encfs_vault
alias vmnt=_mount_encfs_vault
alias vumnt=_unmount_encfs_vault
alias vmntd=_encfs_vault_mounted

# xclip copy paste aliases
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'

# xsel copy paste aliases
alias xci='xsel --clipboard --input'
alias xco='xsel --clipboard --output'

alias tree="tree --filesfirst --sort=name -C"
alias v="$EDITOR"

alias lssh-add=_ssh_add_key
alias lssh-agent=_start_ssh_agent_daemon
alias ex_alias=_expand_alias
# alias wtf=_explain_exit_status
alias tcommits=_total_commits
