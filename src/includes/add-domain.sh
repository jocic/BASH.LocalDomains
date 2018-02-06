#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script Version: 1.0.3                                           #
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
cert_file_pattern="{{ cert_file }}";
cert_key_pattern="{{ cert_key }}";
config_filename_pattern="[^a-zA-Z0-9]";

###################
# OTHER VARIABLES #
###################

cert_folder="";
hosts_line="";
temp="";

###############################
# STEP 1 - LOAD APACHE CONFIG #
###############################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Loading apache configuration template...";
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
    echo -e "- Processing apache configuration template...";
fi

apache_config="${apache_config//$domain_pattern/$domain}";
apache_config="${apache_config//$root_dir_pattern/$root_dir}";
apache_config="${apache_config//$server_admin_pattern/$server_admin}";
apache_config="${apache_config//$cert_file_pattern/$cert_file}";
apache_config="${apache_config//$cert_key_pattern/$cert_key}";

#####################################
# STEP 3 - GENERATE CONFIG FILENAME #
#####################################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Generating apache configuration filename...";
fi

config_filename="${domain//$config_filename_pattern/_}.conf";

##############################
# STEP 4 - SAVE CONFIG FILES #
##############################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Saving apache configuration...";
fi

echo "$apache_config" > "/etc/apache2/sites-available/$config_filename";
echo "$apache_config" > "/etc/apache2/sites-enabled/$config_filename";

####################################
# STEP 5 - CREATE CERT DIRECTORIES #
####################################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Creating SSL directories (if they don't exist)...";
fi

cert_folder=$(dirname "$cert_file");

if [ ! -d "$cert_folder" ]; then
  mkdir -p -m 700 $cert_folder
fi

cert_folder=$(dirname "$cert_key");

if [ ! -d "$cert_folder" ]; then
  mkdir -p -m 700 $cert_folder
fi

###################################
# STEP 6 - ADD DUMMY CERTIFICATES #
###################################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Adding dummy SSL certificates...";
fi

cp "$source_dir/templates/dummy-cert.crt" $cert_file;
cp "$source_dir/templates/dummy-cert.key" $cert_key;

##################################
# STEP 7 - CREATE ROOT DIRECTORY #
##################################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Creating root directory (if it doesn't exist)...";
fi

if [ ! -d "$DIRECTORY" ]; then
  mkdir -p -m 777 /var/apache2/ssl
fi

##################################
# STEP 8 - ENABLE REWRITE MODULE #
##################################

temp=$(ls /etc/apache2/mods-enabled/ | grep -c "rewrite");

if [ $temp == 0 ]; then
    
    echo -e "\nRewrite module is currently disabled.\n";
    
    read -p "Enable rewrite module? (y/n) - " -n 1 temp;
    
    echo -e "\n";
    
    if [[ $temp =~ ^[Yy]$ ]]; then
        a2enmod rewrite;
    fi
    
fi

##############################
# STEP 9 - ENABLE SSL MODULE #
##############################

if [ $enable_ssl == "yes" ]; then
    
    temp=$(ls /etc/apache2/mods-enabled/ | grep -c "ssl");
    
    if [ $temp == 0 ]; then
        
        echo -e "\nRewrite module is currently disabled.\n";
        
        read -p "Enable SSL module? (y/n) - " -n 1 temp;
        
        echo -e "\n";
        
        if [[ $temp =~ ^[Yy]$ ]]; then
            a2enmod ssl;
        fi
        
    fi
    
fi

##########################
# STEP 10 - ADD HOSTNAME #
##########################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Adding domain to the \"/etc/hosts\" list...";
fi

hosts_data=$(cat "/etc/hosts");
hosts_line="127.0.1.1	$domain";

hosts_data="${hosts_data//\n$hosts_line/}"; # Prevent Duplicate Lines
hosts_data="${hosts_data//$hosts_line/}"; # Prevent Duplicate Lines

echo -e "$hosts_data\n$hosts_line" > "/etc/hosts";

###########################
# STEP 11 - RESTART APACHE #
###########################

if [ $verbose_mode == "yes" ]; then
    echo -e "- Restarting apache...";
fi

service apache2 restart;
