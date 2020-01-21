#!/bin/bash

# use 'dryrun' for a dryrun of the script
# when the rolling average over of cpu usage over the last
# REQUIRED_SAMPLES reading is greater than $THRESHOLD % the sleep command will be run.
# If the last sample is stale then reset sample

# With the current constants best to run every 5 minutes
FILENAME=/tmp/cpu-utilization.log
# for 5 minutes interval 12 samples gives a rolling 1 hr average
REQUIRED_SAMPLES=12
THRESHOLD=4
SLEEP_CMD='systemctl suspend'
# if the file has not been updated in this duration then restart sampling
STALE_DURATION=1800

if [ "$1" == 'dryrun' ]; then
    echo DRYRUN
fi

# see if the log file should be truncated because it is stale
LAST_SAMPLE_TIME=$(date +%s -r $FILENAME)
CURRENT_TIME=$(date +%s)
TIME_SINCE_LAST_SAMPLE=$((CURRENT_TIME - LAST_SAMPLE_TIME))
echo "Last sample in '${FILENAME}' taken ${TIME_SINCE_LAST_SAMPLE} seconds ago."
if (( $TIME_SINCE_LAST_SAMPLE > $STALE_DURATION )); then
    echo "   this is more than the stale duration of ${STALE_DURATION} secs, truncating file."
    rm $FILENAME
else
    echo "   less than/equal to stale duration of ${STALE_DURATION}, adding new sample"
fi

# append current utilization to utilization file
CURRENT_UTILIZATION=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
DATE=`date`
echo At $DATE cpu at ${CURRENT_UTILIZATION}%
echo $CURRENT_UTILIZATION >> $FILENAME

# keep the last 3 values
tail -n $REQUIRED_SAMPLES $FILENAME | sponge $FILENAME

# use datamash for mean
UTILIZATION=`cat $FILENAME | datamash mean 1`

# test the length of the file
SAMPLES=`wc $FILENAME -l | cut -f 1 -d ' '`

echo "Mean utilization (n=${SAMPLES}/${REQUIRED_SAMPLES}) readings was ${UTILIZATION}%"

if (( $(echo "$CURRENT_UTILIZATION < $THRESHOLD" |bc -l) &&
      $REQUIRED_SAMPLES == $SAMPLES &&
      $(echo "$UTILIZATION < $THRESHOLD" |bc -l) )); then
    echo "Sending Sleep Command! mean-cpu ${UTILIZATION}% < ${THRESHOLD}% && current-cpu ${CURRENT_UTILIZATION}% < ${THRESHOLD}%"
    if [ "$1" != 'dryrun' ]; then
        $SLEEP_CMD
    fi
else
    echo "Do Nothing! mean-cpu ${UTILIZATION}% >= ${THRESHOLD}% || current-cpu ${CURRENT_UTILIZATION}% >= ${THRESHOLD}% || ${SAMPLES} samples < ${REQUIRED_SAMPLES}"
fi
