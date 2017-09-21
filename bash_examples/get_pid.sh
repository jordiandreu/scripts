#!/usr/bin/env bash
PID="$(ps aux | grep -v "grep" | grep "firefox" | awk '{ print $2; }')"
echo "${PID}"
