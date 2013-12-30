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
#  $Id: esis_update_files.sh 13 2009-07-07 15:15:32Z tburdairon $
#

#
# Update an installation of ESIS (only esis files)
#
# arg1 : new ESIS files (/opt/ESIS/newESIS)
# arg2 : ESIS installation directory (/opt/ESIS)
#
# replace files from current ESIS version with files from new version
#

if [ $# -lt 2 ]; then
    echo "Expected arguments (options) <new ESIS files> <ESIS installation directory> are not present"
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
savedir=.save.`/usr/bin/perl -e 'printf "%d\n", time;'`

echo "Copying ESIS files from $newesis to $oldesis. Old files are going to be copied in $savedir"

mkdir $savedir

#import our functions
. bin/esis_library.sh

# first step, test that all new files are here. 
for j in test_replace_file replace_file
  do
# bin/
# not replaced : there can be customer modifs there
#esis_daily
#esis_report
  for i in `ls bin/ | grep esis | grep -v esis_daily | grep -v esis_report`
   do
    $j bin $i
   done


## libexec/
  for i in esis-commons.jar esis-external-lib.jar esis-probes.jar esis-web.jar 
  do
    $j libexec $i
  done

# replace files in webapps/
  $j webapps esis.war

# replace files in share/ESIS/
  for i in esis-commons.jar esis-external-lib.jar esis-probes.jar esis-web.jar esis.war esis_schema.sql esis_text_en.sql esis_text_fr.sql esis_text_update_en.sql esis_text_update_fr.sql extra_schema.ldif icon.gif lighttpd.conf patch_catalina_sh pg_hba.conf postgresql.conf.developer postgresql.conf.lowmem postgresql.conf.sample publicStore server.xml-customer setenv_sh_catalina slapd.conf slave_schema.sql tomcat_log4j.properties web.xml-customer upgrades.xml supported-products.xml
  do
    $j share/ESIS $i
  done
  
# replace full subdirectories of share/ESIS/ : sql reports lang/upgrade lighttpd
  for i in sql reports lighttpd customer lang
  do
    $j share/ESIS $i isdir
  done
  

  

#do not copy the lang directory : some customers have customized their labels

if [ $j = 'test_replace_file' ]; then
    echo "All files seem to be present. Begin copy operation"
  fi
done

echo "ESIS files successfully copied from $newesis to $oldesis. Old files copied in $savedir"
