#! /bin/bash 

# r: the package is marked for removal.
# c: the configuration files are currently present in the system 

# In uml, we only allow su to execute privileged commands, i.e. no sudo!
cat /proc/cpuinfo | grep "User Mode Linux"
UML=$?

if [ $UML -eq 0 ] 
  then if [ $EUID -eq 0 ]
         then apt-get purge $(dpkg -l | awk '/^rc/ { print $2 }'); apt-get autoremove 
       else echo "User Mode Linux: Must be su to execute this command."
            exit 1
       fi
else 
  if [ $EUID -ne 0 ]
    then sudo echo "Super User passwd, please:"
         if [ $? -ne 0 ]
           then  echo "Sorry, need su privilege!"
                 exit 2
         fi
  fi
  
  # sudo passwd is a valid one.
  sudo apt-get purge $(dpkg -l | awk '/^rc/ { print $2 }'); sudo apt-get autoremove
fi
