#!/bin/bash

# copy to /lib/systemd/system-sleep/suspend-notify.sc to get notifications of sleep and awakening
if [ "${1}" == "pre" ]; then
    # Do the thing you want before suspend here, e.g.:
    msg="`uname -n` suspending at $(date)"
elif [ "${1}" == "post" ]; then
    # Do the thing you want after resume here, e.g.:
    msg="`uname -n` awakened at $(date)"
else
    echo "first argument must be 'pre' or 'post'"
    exit 1
fi

echo $msg >> /tmp/systemd_suspend_test

WEBHOOK=`su delano -c 'source ~/.bash_profile && echo $FANTASY_SLACK_WEBHOOK_URL'`
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$msg\"}" $WEBHOOK
