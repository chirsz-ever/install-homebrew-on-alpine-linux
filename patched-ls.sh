#!/bin/sh -e

# just ignore -q

finished=
first=1

for arg do
    case "$first" in 1)
        set --
        first=
    esac

    skip=

    case "$finished" in '')
        case "$arg" in
        -q)
            skip=1
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

    case "$skip" in '')
        set -- "$@" "$arg"
    esac
done

busybox ls "$@"
