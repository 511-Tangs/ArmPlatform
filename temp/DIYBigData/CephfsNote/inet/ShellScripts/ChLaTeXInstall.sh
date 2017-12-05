#!/bin/bash
cwd=`pwd`

cd $HOME/ChLaTeX

if [ ! -f ChFont-*.tgz ]
   then echo "Font Files tar file does not exist."
        exit 1
elif [ ! -f latex-files.tgz ]
   then echo "ChLaTeX implementation tar file does not exist."
        exit 2
fi

tar -zxvf ChFont-*.tgz
tar -zxvf latex-files.tgz

if [ ! -f var/lib/texmf/fonts/pk/cx/cheuc/chfs834.300pk ]
  then echo "chfs834.300pk missing, something wrong about font files."
       exit 3
fi

if [ ! -d /var/lib/texmf/fonts ]
  then echo "/var/lib/texmf/fonts does not exist, something wrong.  Probably,"
       echo "you need to install packages: jadetex, latex2html, texlive-base," 
       echo "  texlive-base-bin, texlive-fonts-recommended, texlive-latex-base,"
       echo "  texlive-latex-recommended, first."
       exit 4
fi

if [ ! -d /var/lib/texmf/fonts/pk ]
  then sudo mkdir /var/lib/texmf/fonts/pk 
       sudo mkdir /var/lib/texmf/fonts/tfm
elif [ -f /var/lib/texmf/fonts/pk/cx/cheuc/chfs946.300pk -o -f /var/lib/texmf/fonts/pk/ljfour/cheuc/chfs946.600pk ]
  then echo "It seems pk files for ChLaTeX existed."
       exit 5
fi

cd  /var/lib/texmf/fonts/pk

if [ ! -d cx -o ! -d ljfour ]
  then
       sudo mkdir cx ljfour
       sudo mkdir cx/cheuc ljfour/cheuc
       cd ../tfm
       sudo mkdir cheuc; sudo mkdir cheuc/chfs
fi

cd $HOME/ChLaTeX

cd var/lib/texmf/fonts/pk/cx/cheuc
sudo cp chfs*.300pk /var/lib/texmf/fonts/pk/cx/cheuc
cd ../../ljfour/cheuc
sudo cp chfs*.600pk /var/lib/texmf/fonts/pk/ljfour/cheuc
cd ../../../tfm/cheuc/chfs
sudo cp chfs*.tfm /var/lib/texmf/fonts/tfm/cheuc/chfs


#  It seems Debian no longer use /var/cache/fonts directory.
#  Let us end here.

if [ ! -d /usr/local/share/texmf ]
  then sudo mkdir /usr/local/share/texmf
fi

cd /usr/local/share/texmf

if [ ! -d tex ]
  then sudo mkdir tex
       sudo mkdir tex/ChEUC
fi

cd  tex/ChEUC
sudo cp $HOME/ChLaTeX/usr/local/share/texmf/tex/ChEUC/* .

echo "Now you are ready to modify texmf.cnf and execute texconfig."
cd $cwd

