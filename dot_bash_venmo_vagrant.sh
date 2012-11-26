# add this to it
export VGIT_USERNAME=delano
export EDITOR=vi

PS_BLUE="\[\e[34;1m\]"
PS_GRAY="\[\e[30;1m\]"
PS1="\n(${PS_BLUE}\u@\h\[${PS_GRAY})-(${PS_BLUE}\$(date +%k:%M:%S)${PS_GRAY})-(\!)\n[${PS_BLUE}\w${PS_GRAY}] > "

alias venmo_slave_tunnels="/vagrant_data/venmo-data-science/util/create_slave_tunnels.sh $VENMO_DATA_SCIENCE_SERVER_USER"
alias venmo_dash_server_slaves="cd /ebs/appvenmo && export DJANGO_SETTINGS_MODULE=settings_reporting_slaves && /ebs/venmo-ve/bin/ipython -- /ebs/appvenmo/dashboard/main.py --port=7001"
alias venmo_shell_slaves="cd /ebs/appvenmo && export APPROOT=/ebs/appvenmo && export PYTHONPATH=/ebs/appvenmo:/ebs/venmo-data-science && export DJANGO_SETTINGS_MODULE=settings_reporting_slaves && ipython --pdb manage.py shell -- --settings=settings_reporting_slaves"

