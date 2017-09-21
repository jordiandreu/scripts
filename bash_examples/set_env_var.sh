#!/bin/bash

#export POST_PROCESSING_SCRIPTS_ROOT="/home/jandreu/Development/BL13-XALOC/bl13_processing"
printenv | grep "POST_PROCESSING_SCRIPTS_ROOT"

if [ -z ${POST_PROCESSING_SCRIPTS_ROOT+x} ]; then echo "var is unset"; else echo "var is set to '$POST_PROCESSING_SCRIPTS_ROOT'"; fi

