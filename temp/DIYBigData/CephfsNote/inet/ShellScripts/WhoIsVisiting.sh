#! /bin/bash
# This script uses infomation in Access.log and Access.log.1 to find out the countries
# our http visitors are from.

if [ $UID -ne 0 ]
  then echo "Need to be super user to execute this script, quit!"
       exit 1
elif [ ! -f /usr/bin/dig ]
  then echo "Need dig utility for reversing IP"
       echo " Use \"apt-get install dnsutils\" to install it"
       exit 2
fi

>/tmp/Access.log

if [ $# -eq 0 ]
  then cat /var/log/apache2/access.log >>/tmp/Access.log
       cat /var/log/apache2/access.log.1 >>/tmp/Access.log
else 
  while [ $# -gt 0 ]
    do
      cat $1 >>/tmp/Access.log;
      shift;
    done
fi


>hosts.txt

for ip in `cat /tmp/Access.log | egrep -o [0-9]+[.-][0-9]+[.-][0-9]+[.-][0-9]+ | sort -n | uniq`; 
do 
  count=0; 
  count=`cat /tmp/Access.log | egrep -o ${ip} | wc -l`

  Country="";
  IP="";

  if [ -f /usr/bin/geoiplookup ]
    then IP=`echo ${ip} | sed s/-/./g`
         Country=`geoiplookup ${IP} | sed 's/GeoIP\ Country\ Edition://'`
  fi 

  if [ "x${IP}" = "x" ]
    then echo "${ip} Login: ${count} times" >> hosts.txt;
  else echo "${ip} Login: ${count} times" from ${Country}>> hosts.txt; 
  fi

#
# Delete the Query, SERVER, WHEN, and MSG 4 useless lines 
#
  dig -x ${ip} | sed '/^;;\ [QSWM][uEHS][eREG].*$/d' >> hosts.txt; 
  echo >> hosts.txt; 
done

rm /tmp/Access.log
