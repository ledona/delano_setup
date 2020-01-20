# use add to crono and run every 5 minutes, when the rolling average over the last
# N_TO_USE reading is greater than $THRESHOLD % the sleep command will be run


FILENAME=/tmp/cpu-utilization.log
N_TO_USE=12
THRESHOLD=4
SLEEP_CMD='systemctl suspend'

if [ "$1" == 'dryrun' ]; then
    echo DRYRUN
fi

# append current utilization to utilization file
CURRENT_UTILIZATION=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
DATE=`date`
echo At $DATE cpu at ${CURRENT_UTILIZATION}%
echo $CURRENT_UTILIZATION >> $FILENAME

# keep the last 3 values
tail -n $N_TO_USE $FILENAME | sponge $FILENAME

# use datamash for mean
UTILIZATION=`cat $FILENAME | datamash mean 1`

echo "Mean utilization for last $N_TO_USE readings was ${UTILIZATION}%"

if (( $(echo "$CURRENT_UTILIZATION < $THRESHOLD" |bc -l) && $(echo "$UTILIZATION < $THRESHOLD" |bc -l) )); then
    echo "Sending Sleep Command! mean-cpu ${UTILIZATION}% < ${THRESHOLD}% && current-cpu ${CURRENT_UTILIZATION}% < ${THRESHOLD}%"
    if [ "$1" != 'dryrun' ]; then
        $SLEEP_CMD
    fi
else
    echo "Do Nothing! mean-cpu ${UTILIZATION}% >= ${THRESHOLD}% || current-cpu ${CURRENT_UTILIZATION}% >= ${THRESHOLD}%"
    echo Do Nothing!
fi
