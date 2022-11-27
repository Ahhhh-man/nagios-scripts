#!/bin/bash

SCRIPT=$0
VERSION="1.0"
AUTHOR="Aman"

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# exit statuses recognized by Nagios
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# helper functions
have_command () {
  type "$1" >/dev/null 2>/dev/null
}

require_command () {
  if ! have_command "$1"; then
    error 1 "Could not find required command '$1' in system PATH. Aborting."
  fi
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# help/usage function
help () {
cat <<EOF
Name: check_temp - Nagios plugin to check temperature
Version: $VERSION
Author: $AUTHOR

Description:
This script checks the temperature of a given hardware using the lm-sensors
command. It will alert you if the temperature is above the warning/critical 
threshold. 

Options:
    --help, -h          Print this help text.
    --version, -v       Print version information.
    --warning, -w       The warning threshold.
    --critical, -c      The critical threshold.

Example:
    $SCRIPT
EOF
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

check_ntpd () {
    # check is lm-sensors is installed
    require_command sensors
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WARNING_THRESHOLD=10000
CRITICAL_THRESHOLD=60000


while [ $# -gt 0 ]; do
    case "$1" in
        --help|-h)    help; exit 0 ;;
        --version|-v) echo "v$VERSION"; exit 0 ;;
        --warning|-w) WARNING_THRESHOLD="$2"; shift ;;
        --critical|-c) CRITICAL_THRESHOLD="$2"; shift ;;
        --)           shift; break ;;
    esac
    shift
done

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

check_temp