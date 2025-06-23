# shellcheck shell=bash

#-- Determine library directory for importing other library files.
#-- They should always be located alongside us.
if [[ -z "${LIBRARY_DIR}" ]]; then
    LIBRARY_DIR="$(
        # Get the directory this script is located in.
        function get_script_directory() {
            local SOURCE_PATH;
            local SYMLINK_DIR;
            local SCRIPT_DIR;
            case "${SHELL}" in
                *bash)
                    SOURCE_PATH="${BASH_SOURCE[0]}";
                ;;
                *zsh)
                    #-- This is APPARENTLY valid syntax for zsh specifically
                    # shellcheck disable=SC2296
                    SOURCE_PATH="${(%):-%x}";
                ;;
                *ksh)
                    #-- This is APPARENTLY valid syntax for ksh specifically
                    # shellcheck disable=SC2296
                    SOURCE_PATH="${.sh.file}";
                ;;
            esac
            while [ -L "${SOURCE_PATH}" ]; do
                SYMLINK_DIR="$(cd -P "$(dirname "${SOURCE_PATH}")" > /dev/null 2>&1 && pwd)"
                SOURCE_PATH="$(readlink "${SOURCE_PATH}")";
                if [[ "${SOURCE_PATH}" != /* ]]; then
                    SOURCE_PATH="${SYMLINK_DIR}/${SOURCE_PATH}";
                fi
            done
            SCRIPT_DIR="$(cd -P "$( dirname "${SOURCE_PATH}" )" > /dev/null 2>&1 && pwd)"
            echo "${SCRIPT_DIR}"
        }
        get_script_directory;
    )";
fi

#-- Sourcing guard
if [[ -n "${__LIB_OS}" ]]; then
    return 0;
fi
declare __LIB_OS="1";

source "${LIBRARY_DIR}/logging.sh";

# Get the current Linux distribution name.
function get_distro() {
    local -a HAYSTACK;
    local LINE;
    local OS_INFO;
    if [[ -f "$(which lsb_release)" ]]; then
        lsb_release -si 2> /dev/null;
        return $?;
    elif [[ -f "$(which hostnamectl)" ]]; then
        while IFS='' read -r LINE; do HAYSTACK+=("$LINE"); done < <(hostnamectl 2> /dev/null)
        for LINE in "${HAYSTACK[@]}"; do
            if [[ "$LINE" =~ Operating\ System:\  ]]; then
                #-- Rip off the preceding "Operating System: "
                OS_INFO="${LINE##Operating System: }";
                #-- Rip off the trailing "GNU/..."
                echo "${OS_INFO%%GNU*}";
                return 0;
            fi
        done
        return 1;
    fi
    return 1;
}
