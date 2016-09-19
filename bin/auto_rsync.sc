#!/bin/sh
# reliable file transfer
# based on http://x-ian.net/2009/05/15/resume-rsync-transfer-after-ssh-connection-crash/

# try rsync for x times
I=1
while true
do
  TIME=`date`
  echo $I. start of rsync at $TIME, trying to connect ...
  rsync -havv --bwlimit=$1 --progress --partial -e 'ssh -p 8822' $2 $3
  LAST_EXIT_CODE=$?
  # if [ $LAST_EXIT_CODE -eq 0 ]; then
    break
  # fi
  echo sleeping for 1 hour
  sleep 1h
done

# check if successful
if [ $LAST_EXIT_CODE -ne 0 ]; then
  echo rsync failed for $I times. giving up.
else
  echo rsync successful after $I times.
fi

