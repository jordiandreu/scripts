#!/bin/bash

if [ "$#" -eq 0 ]
then   # Script needs at least one command-line argument.
  echo "Usage $0 <oldest log date in format YYYY-MM-DD"
  exit -1
fi

bl="$(hostname | sed 's/[^0-9]//g' | cut -c1,2)"
echo "*** Gathering log for beamline BL${bl}"

date "+%Y-%m-%d" -d "$1" > /dev/null 2>&1
is_valid=$?
if [ $is_valid != 0 ]; then
echo "Invalid date format"
exit -2
fi

fname="mslogbl${bl}.txt"
echo "*** Creating file ${fname}"
cat $(ls -tr $(find . -maxdepth 1 -newermt "${1}" -type f | grep -E "log.txt($|\.([0-9]|[0-9][0-9]|[0-9][0-9][0-9])$)")) > "${fname}";
echo "*** Compressing"
tar -czvf "${fname}"{.tar.gz,}
echo "[DONE]"
