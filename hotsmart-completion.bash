#/usr/bin/env bash

cli=$0
connect="connect"
c="c"
completion="completion"
C="C"

_hotsmart_completions() {

    if [ "${#COMP_WORDS[@]}" -le "2" ]; then
        COMPREPLY=($(compgen -W "connect c disconnect d locations h completion C" -- "${COMP_WORDS[1]}"))
    elif [ "${#COMP_WORDS[@]}" -le "3" ]; then
        if [ "${COMP_WORDS[1]}" == "$connect" ] || [ "${COMP_WORDS[1]}" == "$c" ]; then
            COMPREPLY=($(compgen -W "de il se" -- "${COMP_WORDS[2]}"))
        elif [ "${COMP_WORDS[1]}" == "$completion" ] || [ "${COMP_WORDS[1]}" == "$C" ]; then
            COMPREPLY=($(compgen -W "bash" -- "${COMP_WORDS[2]}"))
        fi
    fi
}

complete -F _hotsmart_completions hotsmart
