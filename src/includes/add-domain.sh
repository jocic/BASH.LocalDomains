#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
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
filename_prefix="";

#####################
# PATTERN VARIABLES #
#####################

domain_pattern="{{ domain }}";
root_dir_pattern="{{ root_dir }}";
server_admin_pattern="{{ server_admin }}";
ssl_cert_pattern="{{ cert_file }}";
ssl_key_pattern="{{ key_file }}";
ssl_chain_pattern="{{ chain_file }}";
filename_prefix_pattern="[^a-zA-Z0-9]"; # For Some Reason [A-z] Does Not Work

###################
# OTHER VARIABLES #
###################

domain_line="";
domain_regex="";
temp="";

###############################
# STEP 1 - LOAD APACHE CONFIG #
###############################

if [ $verbose_mode = "yes" ]; then
    printf "\n- Loading apache configuration template...\n";
fi

if [ $enable_ssl = "yes" ]; then
    apache_config=$(cat "$source_dir/templates/with-ssl.conf");
else
    apache_config=$(cat "$source_dir/templates/without-ssl.conf");
fi

#####################################
# STEP 2 - GENERATE CONFIG FILENAME #
#####################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Generating filename prefix for necessary files...\n";
fi

filename_prefix="${domain//$filename_prefix_pattern/_}";

##################################
# STEP 3 - PROCESS APACHE CONFIG #
##################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Processing apache configuration template...\n";
fi

apache_config="${apache_config//$domain_pattern/$domain}";
apache_config="${apache_config//$root_dir_pattern/$root_dir}";
apache_config="${apache_config//$server_admin_pattern/$server_admin}";
apache_config="${apache_config//$ssl_cert_pattern/\/etc\/ssl\/certs\/$filename_prefix.pem}";
apache_config="${apache_config//$ssl_key_pattern/\/etc\/ssl\/private\/$filename_prefix.pem}";
apache_config="${apache_config//$ssl_chain_pattern/\/etc\/ssl\/chains\/$filename_prefix.pem}";

####################################
# STEP 4 - ADD CONFIGURATION FILES #
####################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Saving apache configuration...\n";
fi

echo "$apache_config" > "/etc/apache2/sites-available/$filename_prefix.conf";
ln -sr "/etc/apache2/sites-available/$filename_prefix.conf" "/etc/apache2/sites-enabled/$filename_prefix.conf";

######################################
# STEP 5 - CREATE CERTIFICATE FOLDER #
######################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Creating SSL directory (if it doesn't exist)...\n";
fi

if [ ! -d "/etc/ssl/chains" ]; then
  mkdir -p -m 700 "/etc/ssl/chains";
fi

##################################
# STEP 6 - ADD CERTIFICATE FILES #
##################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Adding dummy SSL certificates...\n";
fi

cp "$cert_file" "/etc/ssl/certs/$filename_prefix.pem";

cp "$key_file" "/etc/ssl/private/$filename_prefix.pem";

cp "$chain_file" "/etc/ssl/chains/$filename_prefix.pem";

##################################
# STEP 7 - CREATE ROOT DIRECTORY #
##################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Creating root directory (if it doesn't exist)...\n";
fi

if [ ! -d "$DIRECTORY" ]; then
    mkdir -p -m 777 /var/apache2/ssl
fi

##################################
# STEP 8 - ENABLE REWRITE MODULE #
##################################

temp=$(ls /etc/apache2/mods-enabled/ | grep -c "rewrite");

if [ $temp = 0 ]; then
    
    printf "\nRewrite module is currently disabled.\n\n";
    
    read -rp "Enable rewrite module? (y/n) - " -n 1 temp && printf "\n";
    
    if [ -n "$(echo "$temp" | grep -oP "$yes_regex")" ]; then
        a2enmod rewrite;
    fi
    
fi

##############################
# STEP 9 - ENABLE SSL MODULE #
##############################

if [ $enable_ssl = "yes" ]; then
    
    temp=$(ls /etc/apache2/mods-enabled/ | grep -c "ssl");
    
    if [ $temp = 0 ]; then
        
        printf "\nRewrite module is currently disabled.\n\n";
        
        read -rp "Enable SSL module? (y/n) - " -n 1 temp && printf "\n";
        
        if [ -n "$(echo "$temp" | grep -oP "$yes_regex")" ]; then
            a2enmod ssl;
        fi
        
    fi
    
fi

##########################
# STEP 10 - ADD HOSTNAME #
##########################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Adding domain to the \"/etc/hosts\" list...\n";
fi

hosts_data=$(cat "/etc/hosts");

domain_regex="^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)+($domain)$";
domain_line="$ip_address\t$domain";

hosts_data=$(sed -r "s/$domain_regex/{new-line-workaround}/" <<< $hosts_data); # Prevent Duplicate Lines
hosts_data=$(sed -z "s/{new-line-workaround}\n//g" <<< $hosts_data); # Remove New Line (SED Workaround)

echo -e "$hosts_data\n$domain_line" > "/etc/hosts";

##################################
# STEP 11 - PURGE ROOT DIRECTORY #
##################################

if [ $purge = "yes" ]; then
    
    # Purge Directory.
    
    if [ -d $root_dir ]; then
        
        printf "\n";
        
        read -rp "Purge root directory \"$root_dir\"? (y/n) - " -n 1 temp && printf "\n";
        
        if [ -n "$(echo "$temp" | grep -oP "$yes_regex")" ]; then
            find $root_dir -mindepth 1 -delete;
        fi
        
    else
        
        printf -- "- Root directory purging has been skipped as the directory doesn't exist.\n";
        
    fi
    
fi

############################
# STEP 12 - RESTART APACHE #
############################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Restarting apache...\n";
fi

service apache2 restart;
