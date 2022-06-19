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
Name: check_ntp - Nagios plugin to check NTP status
Version: $VERSION
Author: $AUTHOR

Description:
This script checks the status of the ntpd service. It will also notify
you about any differences in the time between the ntp server and the
client.

Options:
    --help, -h          Print this help text.
    --version, -v       Print version information.
    --ntp-server, -n    The ntp server to check. 
    --warning, -w      The warning threshold. In milliseconds.
    --critical, -c     The critical threshold. In milliseconds.

Example:
    $SCRIPT
    $SCRIPT -n 127.0.0.1
    $SCRIPT -n ntp.example.com -w 10000 -c 60000

EOF
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

check_ntpd () {
    # check if ntpd is running
    if pgrep ntpd > /dev/null; then
        # check if time is in sync
        require_command ntpq

        # check ntp server is given
        if [ -z "$NTP_SERVER" ]; then
            echo "CRITICAL: please specify an ntp server using the --ntp-server option"
            exit $CRITICAL
        fi

        STARRED_SERVER=$(ntpq -p | grep "^*" |  awk '{print $1}' | sed 's/^\*//')

        if [ "$STARRED_SERVER" != "$NTP_SERVER" ]; then
            echo "WARNING: ntpd is running but not using the correct server | datetime=$(date +%d-%m-%YT%H:%M:%S%z)"
            exit $WARNING
        fi

        # check if time is in sync with the ntp server
        DELAY=$(ntpq -p | grep "^*" | awk '{print $8}')
        DELAY=${DELAY%.*}
        # check the offset is within the thresholds
        if [ $DELAY -gt $CRITICAL_THRESHOLD ]; then
            echo "CRITICAL: ntpd is running but not in sync | datetime=$(date +%d-%m-%YT%H:%M:%S%z) | delay=$DELAY"
            exit $CRITICAL
        elif [ $DELAY -gt $WARNING_THRESHOLD ]; then
            echo "WARNING: ntpd is running but not in sync | datetime=$(date +%d-%m-%YT%H:%M:%S%z) | delay: $DELAY"
            exit $WARNING
        else
            echo "OK: ntpd is running and time is in sync | datetime=$(date +%d-%m-%YT%H:%M:%S%z) | delay: $DELAY"
            exit $OK
        fi

    else
        echo "CRITICAL: ntpd is not running."
        exit $CRITICAL
    fi
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
        --ntp-server|-n) NTP_SERVER="$2"; shift ;;
        --)           shift; break ;;
    esac
    shift
done

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

check_ntpd