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
#  $Id: setenv_sh_catalina 13 2009-07-07 15:15:32Z tburdairon $
#

# -----------------------------------------------------------------------------
#  Set Java options
# -----------------------------------------------------------------------------

# We need to tell tomcat that we do not want to call anything related to an X server even when usig awt classes
# Force the use of UTF8 for the JVM (this does not affect JSP encoding and HTTP get parameters)
JAVA_OPTS="$APPSVR_MEMORY_OPTIONS -Dfile.encoding=UTF-8 -Djava.awt.headless=true"; export JAVA_OPTS


###