AUTOSWITCH_ACTIVATE="venv/bin/activate"

function activate_venv() {
  if [[ -v VIRTUAL_ENV || "${1}" = "/" || "${1}" = "${HOME}" ]]; then
    return
  elif [[ -f "${1}/${AUTOSWITCH_ACTIVATE}" ]]; then
    # shellcheck disable=SC1090
    source "${1}/${AUTOSWITCH_ACTIVATE}"
  else
    activate_venv "$(dirname "${1}")"
  fi
}

function venv_name() {
  local path
  path=("${(@s:/:)VIRTUAL_ENV}")
  if [[ "${path[-1]}" = "venv" ]]; then
    printf "%s" "${path[-2]}"
  fi
}

function enable_autoswitch_venv() {
    autoload -Uz add-zsh-hook
    disable_autoswitch_venv
    add-zsh-hook chpwd activate_venv
}

function disable_autoswitch_venv() {
    add-zsh-hook -D chpwd activate_venv
}

enable_autoswitch_venv
activate_venv "${PWD}"
