#! /bin/sh
wget http://groups.csail.mit.edu/mac/ftpdir/scm/slib-3b3.zip
wget http://groups.csail.mit.edu/mac/ftpdir/scm/scm-5e7.zip
wget http://groups.csail.mit.edu/mac/ftpdir/scm/jacal-1c2.zip
unzip slib-3b3.zip
unzip scm-5e7.zip
unzip jacal-1c2.zip
(cd slib; make install)
(cd scm; make scmlit; make scm5; make mydlls; make install)
(cd jacal; make install)

