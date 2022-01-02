AUTOSWITCH_ACTIVATE="venv/bin/activate"

function activate_venv() {
  dir="${1-${PWD}}"
  if [[ -v VIRTUAL_ENV ]] && [[ "${dir}" != "$(dirname ${VIRTUAL_ENV})"* ]]; then
    deactivate
  fi
  if [[ -v VIRTUAL_ENV || "${dir}" = "/" || "${dir}" = "${HOME}" ]]; then
    return
  elif [[ -f "${dir}/${AUTOSWITCH_ACTIVATE}" ]]; then
    # shellcheck disable=SC1090
    source "${dir}/${AUTOSWITCH_ACTIVATE}"
  else
    activate_venv "$(dirname "${dir}")"
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
