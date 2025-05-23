# Set my constants
export CONTENT_DIR="$HOME/Content"
export CONTENT_ETC="$CONTENT_DIR/etc"
export PATH="$CONTENT_ETC/bin:$PATH"
export CONTENT_WORK="$CONTENT_DIR/work"
export CONTENT_CODE="$CONTENT_DIR/code"
export CONTENT_LIB="$CONTENT_CODE/lib"
export CONTENT_CONF="$CONTENT_LIB/conf"
export CONTENT_MEDIA="$CONTENT_ETC/media"
export CONTENT_VENVS="$CONTENT_ETC/venvs"
export PYTHONPATH="$CONTENT_LIB:$PYTHONPATH"
export VAULT_MOUNT_POINT="$CONTENT_DIR/vault"
export PHONE_MOUNT_POINT="$HOME/Phone"
export DEF_PYTHON_ENV="$CONTENT_VENVS/defenv"
export ENCRYPTED_VAULT_DIR="$CONTENT_ETC/evault"
export TODO_LINES_FILE="$CONTENT_ETC/var/todos.txt"
export DEFAULTCHBGPIDFILE="$HOME/.local/share/chbg.pid"

export VIRTUAL_ENV_DISABLE_PROMPT="1"
export STATICS_HOST="localhost"
export MOVIE_HOST="localhost"
export STATICS_PORT="9944"
export MOVIE_PORT="9080"
export EDITOR="nvim"
export PAGER="less"

shopt -s failglob nullglob globstar

