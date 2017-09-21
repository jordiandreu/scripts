#!/usr/bin/env bash

VERSION="0.1.0"
USAGE="$(basename "$0") [-h] [-s n] -- program to calculate the answer to life,
the universe and everything

where:
    -h  show this help text
    -s  set the seed value (default: 42)"

seed=42
while getopts ':hs:' option; do
  case "$option" in
    h) echo "$USAGE"
       exit
       ;;
    v) echo "Version $VERSION"
       exit 0;
       ;;
    s) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$USAGE" >&2
       exit 1
       ;;
    \?)printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$USAGE" >&2
       exit 1
       ;;
    *) echo "Unknown error while processing options"
       exit 0;
       ;;
  esac
done


# $OPTIND is the number of options found by getopts.
# shift n removes n strings from the positional parameters list.
# Thus shift $((OPTIND-1)) removes all the options that have been parsed by
# getopts from the parameters list, and so after that point, $1 will refer to
# the first non-option argument passed to the script.
shift $((OPTIND - 1))


param1=$1
param2=$2

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
   echo "Script is already running"
   exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# --- Body --------------------------------------------------------
#  SCRIPT LOGIC GOES HERE
echo $param1
echo $param2