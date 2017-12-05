#! /bin/bash

if [ $# != 1 ]
  then echo "Change the files and subdirectories of given directory to hsu."
       echo "Usage: $0 given-directory."
       exit 1
fi

if [ ! -d $1 ]
  then echo "Directory $1 does not exist, quit."
       exit 2
fi
 
if [ $UID -ne 0 ]
  then echo "Need to be super user to execute this script, quit!"
       exit 3
fi


cd `dirname $1`
BaseDir=`basename $1`

for dir in `find ${BaseDir} -type d`
  do
      chown hsu:hsu ${dir}
  done

for file in `find ${BaseDir} -type f`
  do
      chown hsu:hsu ${file}
  done
