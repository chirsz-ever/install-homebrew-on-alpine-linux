#!/bin/sh -e

# implement '--max-count'

finished=
first=1

for arg do
    case "$first" in 1)
        set --
        first=
    esac

    case "$finished" in '')
        case "$arg" in
        --max-count)
            arg=-m
            ;;
        --max-count=*)
            arg=-m${arg#--max-count=}
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

busybox grep "$@"
