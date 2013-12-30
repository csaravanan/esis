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
#  $Id: esis_binary_update.sh 13 2009-07-07 15:15:32Z tburdairon $
#

#
# Update an installation of ESIS (only 3rd party files )
#
# arg1 : new ESIS files (/opt/ESIS/newESIS)
# arg2 : ESIS installation directory (/opt/ESIS)
#
# replace 3rd party files from current ESIS version with files from new version
#

if [ $# -ne 2 ]; then
    echo "Expected arguments <new ESIS files> <ESIS installation directory> are not present"
    exit 1
fi

newesis=$1
oldesis=$2

#set to '1' for more logs
DEBUG='0'

#check existence of the 2 directories
if [ ! -d $oldesis ]; then
    echo "the $oldesis directory does not exists"
    exit 1
fi

if [ ! -d $newesis ]; then
    echo "the $newesis directory does not exists"
    exit 1
fi

#date +%s works only on GNU date.
savedir=.bin.`/usr/bin/perl -e 'printf "%d\n", time;'`

echo "Copying 3rd party binaries files from $newesis to $oldesis. Old files are going to be copied in $savedir"

mkdir $savedir

#import our functions
. bin/esis_library.sh

# first step, test that all new files are here. then, do the real replace
for j in test_replace_file replace_file
do
  for i in `ls bin | grep -vi esis`
  do
    $j bin $i
  done
  for i in `ls libexec | grep -vi esis`
  do
    $j libexec $i
  done
  for i in `ls share | grep -vi esis`
  do
    $j share $i isdir
  done
  for i in doc docs etc include info lib man sbin usr www.sunfreeware.com
  do
    #usr and www.sunfreeare.com only distributed on solaris
    if [ -d $newesis/$i ]; then
      $j . $i isdir
    fi
  done
  if [ $j = 'test_replace_file' ]; then
    echo "All files seem to be present. Begin copy operation"
  fi
done

echo "3rd party binaries files successfully copied from $newesis to $oldesis. Old files copied in $savedir"
