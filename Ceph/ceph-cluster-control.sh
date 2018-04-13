#!/bin/bash
### Function Table

# Print Help
function prt_help() {
    echo -ne "
----------------------------------------------------------------------
\tThis script is usde to up and down Ceph service.
----------------------------------------------------------------------

Usage: $0 start|stop|fix [osd_hostname]
Tips: $0 fix ceph-osd0 # Will try to restart osd host's ceph service.
Tips: $0 rm <ID>  # Will try to remove osd.<ID> .


"
}

# Print info
function prt_info () {
    echo -ne "\e[1;49;92m[INFO]\t$@\e[m\n"
}
# Print Warn
function prt_warn() {
    echo -ne "\e[1;49;93m[WARN]\t$@\e[m\n"
}

# Print Error
function prt_err() {
    echo -ne "\e[1;49;91m[ERROR]\t$@\e[m\n"
    exit 1
}

# Main script

if [ "$#" -ge "1" ] ; then
    mode=$1
else
    prt_help
    prt_err "Value not correct."
fi

case $mode in
    "start")
    prt_info "start all ceph service on hosts."
    hosts=$(cat /etc/hosts |egrep [0-9].[0-9].[0-9].[0-9].+$|grep ceph-|sed '/127.0.0.1/d' |awk -F ' ' '{print $2}')
    for ips in $hosts; do
    ssh -t $ips "sudo service ceph stop ;sudo chmod 777 -R /var/run/ceph ; sudo chown -R ceph:ceph /var/run/ceph ; sudo chown -R ceph:ceph /var/lib/ceph ; sudo service ceph start"
    done
    ;;
    "stop")
    prt_info "stop all ceph service on hosts."
    hosts=$(cat /etc/hosts |egrep [0-9].[0-9].[0-9].[0-9].+$|grep ceph-|sed '/127.0.0.1/d' | awk -F ' ' '{print $2 }')
    for ips in $hosts; do
    ssh -t $ips "sudo service ceph stop"
    done
    ;;
    "fix")
    if [ "$#" -eq "2" ]; then
        prt_info "Fix ceph host: $2"
    else
        prt_err "Value not correct."
    fi
    ips=$2
    ssh -t $ips "sudo service ceph stop ;sudo chmod 777 -R /var/run/ceph ; sudo chown -R ceph:ceph /var/run/ceph ; sudo chown -R ceph:ceph /var/lib/ceph ; sudo service ceph start"
    ;;
    "rm")
    if [ "$#" -eq "2" ]; then
        prt_info "Remove osd number."
    else
        prt_err "Value not correct."
    fi
    if [[ $2 =~ ^[0-9]+$ ]]; then
        prt_info "<ID> is a number."
    else
        prt_err "<ID> is not a number."
    fi
    [ -z "$(ceph osd tree |grep osd.$2)" ] && prt_err "No osd.$2 found in ceph cluster."
    prt_info "Start to remove osd.$2"
    ceph osd out $2 ; ceph osd crush remove osd.$2; ceph auth del osd.$2; ceph osd rm $2
    [ "$?" -eq "0" ] && prt_info "Osd remote completed." || prt_err "Osd failed to removed."
    prt_info "Using this commend to remove ceph osd.$2 host : ceph osd crush remove osd.$2_hostname"
    ;;
    *)
    prt_help
    prt_err "Value not correct."
