#!/bin/bash

echo "================================================================="
echo "             Starting  MacroServer log analysis"
echo "================================================================="
echo "Log file: $1"
echo "MacroServer stats since $(tar xOfz $1 |head -n1|cut -c25-47)";
echo "MacroServer Restarts $(zcat $1 | grep -a "Ready to accept request" | cut -c 49-92| wc -l;)"
echo;
echo "runMacro Rankings";
echo "================================================================="
zcat $1 |grep -a "runMacro Macro"|cut -c 101-|cut -d \( -f1| sort|uniq -c|sort -nr ;
echo;
echo "MacroServer Exceptions list";
echo "================================================================="
zcat $1 |grep -a ENDEX |grep -v StopException | cut -c 77- | sort | uniq -c |sort -nr;
echo;

top=5
alines=4
blines=4

# 1) Details for macros with the highest number of exceptions.
echo "Searching top ${top} macros ended with Macroserver Exception:"
echo "================================================================="
zcat $1 | grep -a '(MacroServerException) runMacro' |cut -c 85-| sort | uniq -c | sort -nr | head -${top}
# create a list with all macro names:
macros_list=$(zcat $1 | grep -a '(MacroServerException) runMacro' |cut -c 85-| sort | uniq -c | sort -nr | head -${top} | cut -c 40- |xargs)
echo;

# 2) Get macro dependencies. For each macro, search if the error was raised to a secondary macro
for macro in $macros_list
do
echo "Searching dependencies for macro " $macro:
echo "=========================================================="
zcat $1 | grep -a -B $blines -A $alines -w '(MacroServerException) runMacro '${macro} |grep ENDEX | cut -c 85- | sort | uniq -c | sort -nr
echo " "
done


#3) For each macro name, get the error description
for macro in $macros_list
do
echo "Searching error descriptions for macro " $macro:
echo "=========================================================="
zcat $1 | grep -a -A 40 -w '(MacroServerException) runMacro '${macro} |grep 'desc =' | sort | uniq -c | sort -nr
echo " "
done

