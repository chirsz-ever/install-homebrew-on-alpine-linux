#!/bin/sh -e

# implement '--field-separator' and '--key'

finished=
first=1

for arg do
    case "$first" in 1)
        set --
        first=
    esac

    case "$finished" in '')
        case "$arg" in
        --field-separator)
            arg=-t
            ;;
        --field-separator=*)
            arg=-t${arg#--field-separator=}
            ;;
        --key)
            arg=-k
            ;;
        --key=*)
            arg=-k${arg#--key=}
            ;;
        --)
            finished=1
            ;;
        -*)
            ;;
        *)
            finished=1
            ;;
        esac
    esac

    set -- "$@" "$arg"
done

busybox sort "$@"
