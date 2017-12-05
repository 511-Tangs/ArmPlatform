#! /bin/bash
if [ $# -ne 1 ]
  then echo "Usage: $0 web-site"
  exit 1
fi

wget -p -r -e robots=off -w 15 -random-wait -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.5) Gecko/2008120122 Firefox/3.0.5"  $1

