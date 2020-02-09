#!/bin/bash

# use 'dryrun' for a dryrun of the script
# when the rolling average over of cpu usage over the last
# REQUIRED_SAMPLES reading is greater than $THRESHOLD % the sleep command will be run.
# If the last sample is stale then restart sampling

# With the current constants best to run every 5 minutes
CPU_UTILIZATION_FILENAME=/tmp/sleep-on-inactive-cpu-utilization.txt
# file that the reason will be written to
REASON_FILENAME=/tmp/sleep-on-inactive-reason.txt
# for 5 minutes interval 12 samples gives a rolling 1 hr average
REQUIRED_SAMPLES=12
# CPU usage % threshold
THRESHOLD=1
# command to run as sudo to go to sleep
SLEEP_CMD='systemctl suspend'
# if the file has not been updated in this duration then restart sampling, should help with awakening shortly after sleep
STALE_DURATION=1800

if [ "$1" == 'dryrun' ]; then
    echo DRYRUN: will not actually go to sleep
fi

# see if the log file should be truncated because it is stale
LAST_SAMPLE_TIME=$(date +%s -r $CPU_UTILIZATION_FILENAME)
CURRENT_TIME=$(date +%s)
TIME_SINCE_LAST_SAMPLE=$((CURRENT_TIME - LAST_SAMPLE_TIME))
echo "Last sample in '${CPU_UTILIZATION_FILENAME}' taken ${TIME_SINCE_LAST_SAMPLE} seconds ago."
if (( $TIME_SINCE_LAST_SAMPLE > $STALE_DURATION )); then
    echo "   this is more than the stale duration of ${STALE_DURATION} secs, truncating file."
    rm $CPU_UTILIZATION_FILENAME
else
    echo "   less than/equal to stale duration of ${STALE_DURATION}, adding new sample"
fi

# append current utilization to utilization file
CURRENT_UTILIZATION=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
DATE=`date`
echo At $DATE cpu at ${CURRENT_UTILIZATION}%
echo $CURRENT_UTILIZATION >> $CPU_UTILIZATION_FILENAME

# trim to required samples
tail -n $REQUIRED_SAMPLES $CPU_UTILIZATION_FILENAME | sponge $CPU_UTILIZATION_FILENAME

# use datamash for mean
UTILIZATION=`cat $CPU_UTILIZATION_FILENAME | datamash mean 1`

# test the length of the file
SAMPLES=`wc $CPU_UTILIZATION_FILENAME -l | cut -f 1 -d ' '`

echo "Mean utilization (n=${SAMPLES}/${REQUIRED_SAMPLES}) readings was ${UTILIZATION}%"

if (( $(echo "$CURRENT_UTILIZATION < $THRESHOLD" |bc -l) &&
      $REQUIRED_SAMPLES == $SAMPLES &&
      $(echo "$UTILIZATION < $THRESHOLD" |bc -l) )); then
    reason="mean-cpu ${UTILIZATION}% < ${THRESHOLD}% && current-cpu ${CURRENT_UTILIZATION}% < ${THRESHOLD}%"
    echo $reason > $REASON_FILENAME
    echo "Sending Sleep Command! ${reason}"
    if [ "$1" != 'dryrun' ]; then
        $SLEEP_CMD
    fi
else
    echo "Do Nothing! mean-cpu ${UTILIZATION}% >= ${THRESHOLD}% || current-cpu ${CURRENT_UTILIZATION}% >= ${THRESHOLD}% || ${SAMPLES} samples < ${REQUIRED_SAMPLES}"
fi
