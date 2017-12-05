#!/bin/sh

echo "Setting up IPtables rules"

IPTABLES=/sbin/iptables # where iptables binary lies

# Setting up Forwarding 
echo 1 > /proc/sys/net/ipv4/ip_forward
# Setting up Dynamic IP for diald/masquerading
echo 1 > /proc/sys/net/ipv4/ip_dynaddr
# Increase the binding time
echo 3600 > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout

# Setting up IP spoofing protection 
if [ -e /proc/sys/net/ipv4/conf/all/rp_filter ] 
then 
        for f in /proc/sys/net/ipv4/conf/*/rp_filter 
        do 
                echo 1 > $f 
        done 
fi

# Devices
LOCAL_DEVICE="lo"			# device for localhost
EXTERNAL_DEVICE="ppp0"		# device for Internet
INTERNAL_DEVICE="eth1"		# device for Intranet    
HALFTRUST_NETS="192.168.1.0/8"
KEEPSTATE="-m state --state ESTABLISHED,RELATED"


# Flush all Rules
$IPTABLES 		-F 
$IPTABLES 		-X
$IPTABLES -t nat 	-F
$IPTABLES -t nat 	-X
$IPTABLES -t mangle	-F
$IPTABLES -t mangle	-X

# Deny all by default 
$IPTABLES -P INPUT	DROP 
$IPTABLES -P OUTPUT	DROP 
$IPTABLES -P FORWARD	ACCEPT

$IPTABLES -N ALLOW_PORTS
$IPTABLES -F ALLOW_PORTS


###### TCP and UDP ports ######
TCP_PORTS="21 22 80 1720"
for PORT in $TCP_PORTS; do
	$IPTABLES -A ALLOW_PORTS -m state --state NEW -p tcp --dport $PORT -j ACCEPT
done

UDP_PORTS=""
for PORT in $UDP_PORTS; do
	$IPTABLES -A ALLOW_PORTS -m state --state NEW -p udp --dport $PORT -j ACCEPT
done


###### MASQUERADE ######
$IPTABLES -t nat -A POSTROUTING -d ! 192.168.1.0/24 -o $EXTERNAL_DEVICE -j MASQUERADE

    	    
###### LOCALHOST ######
$IPTABLES -A INPUT -p ALL -i $LOCAL_DEVICE -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -o $LOCAL_DEVICE -j ACCEPT
$IPTABLES -A FORWARD -p ALL -i $LOCAL_DEVICE -j ACCEPT


###### FROM INTRANET ######
$IPTABLES -A INPUT -p ALL -i $INTERNAL_DEVICE -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -o $INTERNAL_DEVICE -j ACCEPT


###### ICMP ######
$IPTABLES -A INPUT -p ICMP -i $EXTERNAL_DEVICE -j ACCEPT
$IPTABLES -A OUTPUT -p ICMP -o $EXTERNAL_DEVICE -j ACCEPT
$IPTABLES -A INPUT -p ICMP -s $HALFTRUST_NETS -j ACCEPT
$IPTABLES -A OUTPUT -p ICMP -d $HALFTRUST_NETS -j ACCEPT


###### ALLOWED PORTS ######
$IPTABLES -A INPUT -i $EXTERNAL_DEVICE -s "0.0.0.0/0" -j ALLOW_PORTS


###### ESTABLISHED MODE ######
$IPTABLES -A OUTPUT -o $EXTERNAL_DEVICE	-p TCP $KEEPSTATE -j ACCEPT
$IPTABLES -A INPUT -i $EXTERNAL_DEVICE -p TCP $KEEPSTATE -j ACCEPT
$IPTABLES -A OUTPUT -o $EXTERNAL_DEVICE	-p UDP $KEEPSTATE -j ACCEPT
$IPTABLES -A INPUT -i $EXTERNAL_DEVICE -p UDP $KEEPSTATE -j ACCEPT


###### OUTPUT ######
$IPTABLES -A OUTPUT -o $EXTERNAL_DEVICE	-p ALL -j ACCEPT
