#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# alias m4n="aft-mtp-mount '$HOME/Phone'"
# alias u4n="umount '$HOME/Phone'"
alias nmcli="nmcli --colors=auto --pretty"

function mnt4nd {
  # [ -e "$CONTENT_ETC/var/phone_mounted" ]
  mountpoint -q "$PHONE_MOUNT_POINT"
}

function mnt4n {
  if mnt4nd; then
    echo >&2 "Phone already mounted."
    return 1
  fi
  chmod 755 "$PHONE_MOUNT_POINT"
  sshfs "phone.butterkup.sn:/storage/emulated/0/" "$PHONE_MOUNT_POINT" -o compression=no\
    -o kernel_cache,attr_timeout=5,entry_timeout=5,ServerAliveInterval=20,no_readahead\
    -o Ciphers=chacha20-poly1305@openssh.com,cache=yes,reconnect,port=8022,auto_unmount\
   || {
    chmod 555 "$PHONE_MOUNT_POINT"
    echo >&2 "Mounting Phone was unsuccessful!"
    return 1
  }
}

function umnt4n {
  if ! mnt4nd; then
    echo >&2 "Phone not Mounted"
    return 1
  fi
  fusermount3 -u "$PHONE_MOUNT_POINT" \
    && chmod 555 "$PHONE_MOUNT_POINT"
}

function pullclones {
  for repo in ~/Clones/*; do
    git -C "$repo" pull
  done
}

function updatepc {
  # Enable united stop/continue signal handling
  sudo pacman -Syu --noconfirm &&\
    rustup update &&\
    pullclones
}
# alias mpv="mpv --background-color='`xrdb -get mpv.background`'"

