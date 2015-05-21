#!/bin/bash

echo "Gathering system info..."

source ../bash/bash.path.rc

_get_nprocs()
{
    NPROCS=$(cat /proc/cpuinfo | grep processor | wc -l)
#    echo $NPROCS
}

get_processor()
{
    for i in name
    do 
	PROC_TYPE=$(cat /proc/cpuinfo | grep name | sed -r 's/model name*.: //'|uniq)
    done
    _get_nprocs
    echo "($NPROCS) "$PROC_TYPE
    
}

get_mem()
{
    for i in MemTotal 
    do
	MEM_TOTAL=$(cat /proc/meminfo | grep $i | sed -r 's/MemTotal://' | sed -e 's/^[ \t]*//')
    done
    echo $MEM_TOTAL
}

get_os()
{
    if [ -f /etc/SuSE-release ]; then
	OS_FILE="/etc/SuSE-release"
	OS_RELEASE=$(cat $OS_FILE | grep openSUSE)
    elif [ -f /etc/os-release ]; then
	OS_FILE="/etc/os-release"
	OS_RELEASE=$(cat $OS_FILE | grep PRETTY_NAME | sed -r 's/'$i'=//'| sed 's/"//g')
    else
        OS_RELEASE="Unknown"
	echo "WARNING: No OS release informatio found!"
    fi
    echo $OS_RELEASE
}

get_kernel()
{
    uname -mrs
}
get_uptime()
{
    UPTIME=$(uptime)
    echo $UPTIME
}

get_filesystem()
{
    df -HiTP | column -t
}

get_home_space()
{
    du -cd 1 /home/$USER --exclude=.* | sort -nr
}

get_path()
{
    path | sort
}

get_ldpath()
{
    ldpath | sort
}

get_ppath()
{
    ppath | sort
}


### Plotting functions ###
## HTML ##
# section2_html function :: 2 arguments (title and section contents)
section_h2_html()
{
    echo "<h2>${1}</h2>"
    echo "<pre>"
    $2
    echo "</pre>"
}

## Redmine ##
section_h2_rmf()
{
    echo "h2. ${1}"
    echo " "
#    echo -e "p.\c"
    $2
    echo " "
}

section_pre_rmf()
{
    echo "h2. ${1}"
    echo " "
    echo "<pre>"
    $2
    echo "</pre>"
}

superscript_rmf()
{
    echo "^${1}^"
}

gets='get_os get_processor get_mem get_uptime' # get_filesystem get_home_space'

#echo "Gathering Info..."
#echo "================="
#for i in $gets
#do
#    $i
#done
#exit

# Create dynamic naming
HTML_FILENAME="${HOSTNAME}.html"
RMF_FILENAME="${HOSTNAME}.rmf "

# Header info
TITLE="System Information for host $HOSTNAME"
RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="(Updated on $RIGHT_NOW by $USER)"

# A script to produce an HTML file
cat > $HTML_FILENAME <<- _EOF_
    <HTML>
    <HEAD>
        <TITLE>
        $TITLE
        </TITLE>
    </HEAD>
    <BODY>
    <H1>$TITLE</H1>
    <P>$TIME_STAMP
    <P>$UPTIME
    $(section_h2_html "Operating System (OS)" get_os)
    $(section_h2_html "Kernel" get_kernel)
    $(section_h2_html "Processor(s) Type" get_processor)
    $(section_h2_html "Total Memory (RAM)" get_mem)
    $(section_h2_html "System PATH" get_path)
    $(section_h2_html "LD Library PATH" get_ldpath)
    $(section_h2_html "Python PATH" get_ppath)
    $(section_h2_html "Filesystem" get_filesystem)
    </BODY>
    </HTML>
_EOF_


# A script to produce a redmine formatted text file
cat > $RMF_FILENAME <<- _EOF_
h1. $TITLE

$(superscript_rmf "$TIME_STAMP")

----

$(section_h2_rmf "Operating System (OS)" get_os)
$(section_h2_rmf "Kernel" get_kernel)
$(section_h2_rmf "Processor(s) Type" get_processor)
$(section_h2_rmf "Total Memory (RAM)" get_mem)

----

$(section_h2_rmf "System PATH" get_path)
$(section_h2_rmf "LD Library PATH" get_ldpath)
$(section_h2_rmf "Python PATH" get_ppath)
$(section_pre_rmf "Filesystem" get_filesystem)
_EOF_

exit


    $(show_home_space)

