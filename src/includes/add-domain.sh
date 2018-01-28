#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script Version: 1.0.1                                           #
# Script License: MIT License (MIT)                               #
# =============================================================== #
# Personal Website: http://www.djordjejocic.com/                  #
# =============================================================== #
# Permission is hereby granted, free of charge, to any person     #
# obtaining a copy of this software and associated documentation  #
# files (the "Software"), to deal in the Software without         #
# restriction, including without limitation the rights to use,    #
# copy, modify, merge, publish, distribute, sublicense, and/or    #
# sell copies of the Software, and to permit persons to whom the  #
# Software is furnished to do so, subject to the following        #
# conditions.                                                     #
# --------------------------------------------------------------- #
# The above copyright notice and this permission notice shall be  #
# included in all copies or substantial portions of the Software. #
# --------------------------------------------------------------- #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND        #
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT     #
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,    #
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, RISING     #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   #
# OTHER DEALINGS IN THE SOFTWARE.                                 #
###################################################################

##################
# CORE VARIABLES #
##################

hosts_data="";
apache_config="";
config_filename="";

#####################
# PATTERN VARIABLES #
#####################

domain_pattern="{{ domain }}";
root_dir_pattern="{{ root_dir }}";
server_admin_pattern="{{ server_admin }}";
config_filename_pattern="[^a-zA-Z0-9]";

###################
# OTHER VARIABLES #
###################

hosts_line="";

###############################
# STEP 1 - LOAD APACHE CONFIG #
###############################

if [ $verbose_mode == "yes" ]; then
    echo -e "1. Loading apache configuration template...";
fi

if [ $enable_ssl == "yes" ]; then
    apache_config=$(cat "$source_dir/templates/with-ssl.conf");
else
    apache_config=$(cat "$source_dir/templates/without-ssl.conf");
fi

##################################
# STEP 2 - PROCESS APACHE CONFIG #
##################################

if [ $verbose_mode == "yes" ]; then
    echo -e "2. Processing apache configuration template...";
fi

apache_config="${apache_config//$domain_pattern/$domain}"
apache_config="${apache_config//$root_dir_pattern/$root_dir}"
apache_config="${apache_config//$server_admin_pattern/$server_admin}"

#####################################
# STEP 3 - GENERATE CONFIG FILENAME #
#####################################

if [ $verbose_mode == "yes" ]; then
    echo -e "3. Generating apache configuration filename...";
fi

config_filename="${domain//$config_filename_pattern/_}.conf";

##############################
# STEP 4 - SAVE CONFIG FILES #
##############################

if [ $verbose_mode == "yes" ]; then
    echo -e "4. Saving apache configuration...";
fi

echo "$apache_config" > "/etc/apache2/sites-available/$config_filename";
echo "$apache_config" > "/etc/apache2/sites-enabled/$config_filename";

##################################
# STEP 5 - CREATE ROOT DIRECTORY #
##################################

if [ $verbose_mode == "yes" ]; then
    echo -e "5. Creating root directory (if it doesn't exist)...";
fi

if [ ! -d "$DIRECTORY" ]; then
  mkdir -p -m 777 $root_dir
fi

#########################
# STEP 6 - ADD HOSTNAME #
#########################

if [ $verbose_mode == "yes" ]; then
    echo -e "6. Adding domain to the \"/etc/hosts\" list...";
fi

hosts_data=$(cat "/etc/hosts");
hosts_line="127.0.1.1	$domain";

hosts_data="${hosts_data//\n$hosts_line/}"; # Prevent Duplicate Lines
hosts_data="${hosts_data//$hosts_line/}"; # Prevent Duplicate Lines

echo -e "$hosts_data\n$hosts_line" > "/etc/hosts";

###########################
# STEP 7 - RESTART APACHE #
###########################

if [ $verbose_mode == "yes" ]; then
    echo -e "7. Restarting apache...";
fi

service apache2 restart;
