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

source "${LIBRARY_DIR}/graphics.sh";
source "${LIBRARY_DIR}/logging.sh";
