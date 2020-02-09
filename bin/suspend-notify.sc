#!/bin/bash

# sleep on inactive reason file, should be the same as the reason file in sleep-on-inactive.sc
REASON_FILENAME=/tmp/sleep-on-inactive-reason.txt

# copy to /lib/systemd/system-sleep/suspend-notify.sc to get notifications of sleep and awakening
if [ "${1}" == "pre" ]; then
    # Do the thing you want before suspend here
    if [ -f "$REASON_FILENAME" ]; then
        # consume the reason
        reason="because: `cat $REASON_FILENAME`"
        rm $REASON_FILENAME
    else
        reason=""
    fi
    msg="`uname -n` suspending at $(date) $reason"
elif [ "${1}" == "post" ]; then
    # Do the thing you want after resume here
    msg="`uname -n` awakened at $(date)"
else
    echo "first argument must be 'pre' or 'post'"
    exit 1
fi

echo $msg >> /var/log/systemd_suspend.log

# update this if the webhook should be found elsewhere (e.g. it may be better if this is just in a file somewhere)
WEBHOOK=`su delano -c 'source ~/.bash_profile && echo $FANTASY_SLACK_WEBHOOK_URL'`
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$msg\"}" $WEBHOOK
