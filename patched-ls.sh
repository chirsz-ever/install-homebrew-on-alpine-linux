#!/bin/sh -e

# remove -q option from arguments, currently busybox does not support it.

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
        --)
            finished=1
            ;;
        -*q*)
            arg="$(echo "$arg" | tr -d q)"
            case "$arg" in -)
                skip=1
            esac
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
