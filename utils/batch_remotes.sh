#!/bin/bash

user=$USER

set -- `getopt "u:" "$@"`

while [ ! -z "$1" ]
do
  case "$1" in
    -u) user=$2
	h1=3
	;;
     *) break;;
  esac
  shift
done

hosts=${@:h1:$#}

# Create list of remote hosts and user for bl13 ONLY if NO ARGUMENTS
if [ "$#" -eq 1 ]; then
  hosts="pcbl1301 pcbl1303 pcbl1304 ibl1301 ibl1302 tbl1301 ctbl13arch01 ctbl13ccd01 bl13pilatus bl13mxcube neptu03"
  user="opbl13"
fi

echo "Usage: $0 [-u,--user] host1 host2 ..."
echo "Default settings: bl13 beamline."
echo "Processing on behalf of $user"
echo "Hosts list: $hosts"
echo ""

# system_page - A script to produce a batch system information HTML/Redmine files
TITLE="Batch System Information for Beamlines"
RIGHT_NOW=$(date +"%x %r %Z")
WORK_DIR=info_$RIGHT_NOW

# Create specific sequence of commands to be executed on the remote host
cmd01="cd /beamlines/bl13/controls/jandreu"
cmd02="cd scripts/utils"
cmd03="./sys_info.sh"

for i in "$cmd01" "$cmd02" "$cmd03"
do
  cmdall="${cmdall}$i; "
done
echo "Remote command:"
echo $cmdall
echo ""

for host in $hosts
do
    echo "Remote processing @ $host"
    echo "+++++++++++++++++"
    echo "User: $user"
    ssh $user@$host $cmdall
    echo "command executed. Logging out from $host"
    echo ""
done

echo "done!"
