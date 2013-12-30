#!/bin/sh
#   
#  ESIS
#  
#  Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
#  
#  Projects contributors : Philippe Le Berre, Thomas Burdairon, Benjamin Baudel,
#                          Benjamin S. Gould, Diego Patinos Ramos, Constantin Cornelie
#  
#  
#  This file is part of ESIS.
#  
#  ESIS is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation version 3 of the License.
#  
#  ESIS is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with ESIS.  If not, see <http://www.gnu.org/licenses/>.
#  
#  $Id: esis_library.sh 13 2009-07-07 15:15:32Z tburdairon $
#

#
# Common methods used for update scripts
#

test_replace_file()
{
  subdir=$1
  filename=$2
  extra=$3
  fullorigfile=$oldesis/$subdir/$filename
  fullnewfile=$newesis/$subdir/$filename
  fullsavefile=$savedir/$subdir/$filename
  if [ $extra ]; then
    if [ "$extra" = "isdir" ]; then
      if [ ! -d $fullnewfile ]; then
        echo "the $fullnewfile directory does not exists. CANCELLING THE UPDATE"
        exit 1
      fi
    fi
  elif [ ! -f $fullnewfile ]; then
    echo "the $fullnewfile file does not exists. CANCELLING THE UPDATE"
    exit 1
  fi
  if [ $DEBUG = '1' ]; then
    echo "marking $fullnewfile as beeing copied to $fullorigfile"
  fi
}

replace_file()
{
  subdir=$1
  filename=$2
  extra=$3
  fullorigfile=$oldesis/$subdir/$filename
  fullnewfile=$newesis/$subdir/$filename
  fullsavefile=$savedir/$subdir/$filename
  if [ $extra ]; then
    if [ "$extra" = "isdir" ]; then
      mkdir -p $fullsavefile
      if [ ! -d $fullnewfile ]; then
        echo "the $fullnewfile directory does not exists. SHOULD NEVER BE THERE !!! ALWAYS CALL test_replace_file"
        exit 1
      fi
    fi
  elif [ ! -f $fullnewfile ]; then
    echo "the $fullnewfile file does not exists. SHOULD NEVER BE THERE !!! ALWAYS CALL test_replace_file"
    exit 1
  fi
  mkdir -p $savedir/$subdir
  if [ "$extra" = "pattern" ]; then
    if [ $DEBUG = '1' ]; then
      echo "mkdir -p $savedir/$subdir"
    fi
    mkdir -p $savedir/$subdir
    if [ $DEBUG = '1' ]; then
      echo "mv $fullorigfile $savedir/$subdir"
    fi
    mv $fullorigfile $savedir/$subdir
    if [ $DEBUG = '1' ]; then
      echo "cp -R $fullnewfile $fullorigfile"
    fi
    cp -R $fullnewfile $oldesis/$subdir
  elif [ "$extra" = "isdir" ]; then
    if [ $DEBUG = '1' ]; then
      echo "mv $fullorigfile $savedir/$subdir"
    fi
    mv $fullorigfile $savedir/$subdir
    if [ $DEBUG = '1' ]; then
      echo "cp -R $fullnewfile $oldesis/$subdir"
    fi
    cp -R $fullnewfile $oldesis/$subdir
  else
    if [ $DEBUG = '1' ]; then
      echo "mkdir -p $savedir/$subdir"
    fi
    mkdir -p $savedir/$subdir
    if [ -f $fullorigfile ]; then
      if [ $DEBUG = '1' ]; then
        echo "mv $fullorigfile $fullsavefile"
      fi
      mv $fullorigfile $fullsavefile
    fi
    if [ $DEBUG = '1' ]; then
      echo "cp -R $fullnewfile $fullorigfile"
    fi
    cp -R $fullnewfile $fullorigfile
  fi
  if [ $DEBUG = '1' ]; then
    echo "$fullnewfile copied to $fullorigfile. Original saved in $fullsavefile"
  fi
}
