#!/bin/bash

top=5
alines=4
blines=4

echo "Searching top ${top} macros which end with Macroserver Exception:"
echo "================================================================="
# 1) Search for macros that has failed:
grep '(MacroServerException) runMacro' ${1} |cut -c 85-| sort | uniq -c | sort -nr | head -${top}
# create a list with all macro names:
macros_list=$(grep '(MacroServerException) runMacro' ${1} |cut -c 85-| sort | uniq -c | sort -nr | head -${top} | cut -c 40- |xargs)


# 2) Get macro dependencies. For each macro, search if the error was raised to a secondary macro
for macro in $macros_list
do
echo "Searching dependencies for macro " $macro:
echo "=========================================================="
grep -B $blines -A $alines -w '(MacroServerException) runMacro '${macro} ${1} |grep ENDEX | cut -c 85- | sort | uniq -c | sort -nr
echo " "
done


#3) For each macro name, get the error description
for macro in $macros_list
do
echo "Searching error descriptions for macro " $macro:
echo "=========================================================="
grep -A 40 -w '(MacroServerException) runMacro '${macro} ${1} |grep 'desc =' | sort | uniq -c | sort -nr
echo " "
done

