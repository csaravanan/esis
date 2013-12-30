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
#  $Id: esis_create_company.sh 13 2009-07-07 15:15:32Z tburdairon $
#

#
# Create a database and initialize it ready to be used
# Parameters : 
# 1 - db name
# 2 - Company name
# 3 - Company short name
# 4 - DB user
# 5 - User password
# if none then exit

. `dirname $0`/esis_env

if [ $# -lt 3 ]
then
  echo "Must be called with the following args esis_create_company.sh [dbname] [Company name] [Company short name] [DB user] [User password]"
  echo "DB user and password are optionnal"
  echo "If not provided, user will be esis_user"
  echo "If not provided, password will be Pa55w0rd"
  exit 1
fi

dbname=$1
ciename=$2
shortname=$3
dbuser=$4
usrpasswd=$5

if [ $dbuser ]
then
 echo "User will be $dbuser"
else
 echo "Setting user to the default user esis_user"
 dbuser="esis_user"
fi

if [ $usrpasswd ]
then
 echo "password wil be $usrpasswd"
else
 echo "Setting user to the default password Pa55w0rd"
 usrpasswd="Pa55w0rd"
fi


if [ $# -ge 4 ]
then
    echo "Creating a database user [$dbuser] with password [$usrpasswd]"
psql --echo-queries postgres <<EOF || exit -1 
CREATE USER $dbuser ENCRYPTED PASSWORD '$usrpasswd' NOCREATEDB NOCREATEUSER;
EOF

# add the created user to the password file  
cat >> $HOME/.pgpass <<EOPG
localhost:5432:*:$dbuser:$usrpasswd
EOPG
    
fi

echo "Initializing a database called [$dbname] owned by [$dbuser]"

# does the db already exists
exists=`psql --list | grep $dbname | wc -l`

if [ $exists = 1 ]
then
  echo "Database [$dbname] already exists"
  exit 1
fi

# create the db + grant on the usual user
psql --echo-queries postgres <<EOF || exit -1 
CREATE DATABASE $dbname  WITH ENCODING 'UTF8' OWNER $dbuser;
GRANT ALL ON DATABASE $dbname TO $dbuser;
EOF

# set public schema owned to slave
psql $dbname <<EOF || exit -1
ALTER SCHEMA public OWNER TO $dbuser;
EOF
# create the procedural language
psql $dbname $dbuser <<EOF || exit -1
CREATE LANGUAGE plpgsql;
EOF

# install dblink commands on database (can only be done by admin user due to 'C' language extension...)
psql $dbname < ${ESIS_HOME}/share/ESIS/sql/schema/slave_dblink.sql || exit -1

echo "Database [$dbname] has been inited, owned by user $dbuser"

# SQL Create basic table tables
psql $dbname $dbuser < ${ESIS_HOME}/share/ESIS/slave_db.sql
psql $dbname $dbuser < ${ESIS_HOME}/share/ESIS/core_schema_files.sql
psql $dbname $dbuser < ${ESIS_HOME}/share/ESIS/esis_text_en.sql


# db has been created, now create the database
${ESIS_HOME}/bin/esis companies add "$ciename" "$shortname" jdbc:postgresql://127.0.0.1:5432/$dbname $dbuser
