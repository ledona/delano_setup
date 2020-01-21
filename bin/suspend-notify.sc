#!/bin/sh
if [ "${1}" == "pre" ]; then
  # Do the thing you want before suspend here, e.g.:
  echo "we are suspending at $(date)..." > /tmp/systemd_suspend_test
elif [ "${1}" == "post" ]; then
  # Do the thing you want after resume here, e.g.:
  echo "...and we are back from $(date)" >> /tmp/systemd_suspend_test
fi
