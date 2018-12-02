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
filename_prefix="";
apache_config="";

#####################
# PATTERN VARIABLES #
#####################

filename_prefix_pattern="[^a-zA-Z0-9]"; # For Some Reason [A-z] Does Not Work

###################
# OTHER VARIABLES #
###################

domain_regex="";

#####################################
# STEP 1 - GENERATE CONFIG FILENAME #
#####################################

if [ $verbose_mode = "yes" ]; then
    printf -- "\n- Generating filename prefix for necessary files...\n";
fi

filename_prefix="${domain//$filename_prefix_pattern/_}";

#######################################
# STEP 2 - REMOVE CONFIGURATION FILES #
#######################################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Removing configuration files...\n";
fi

# Cache Configuration.

apache_config=$(cat "/etc/apache2/sites-available/$filename_prefix.conf");

# Remove Configuration Files.

if [ -f "/etc/apache2/sites-available/$filename_prefix.conf" ]; then
    rm "/etc/apache2/sites-available/$filename_prefix.conf";
fi

if [ -f "/etc/apache2/sites-enabled/$filename_prefix.conf" ]; then
    rm "/etc/apache2/sites-enabled/$filename_prefix.conf";
fi

#####################################
# STEP 3 - REMOVE CERTIFICATE FILES #
#####################################

if [ $verbose_mode = "yes" ]; then
    echo -e "- Removing certificate files...";
fi

if [ -f "/etc/apache2/ssl/$filename_prefix.crt" ]; then
    rm "/etc/apache2/ssl/$filename_prefix.crt";
fi

if [ -f "/etc/apache2/ssl/$filename_prefix.key" ]; then
    rm "/etc/apache2/ssl/$filename_prefix.key";
fi

#########################
# STEP 4 - ADD HOSTNAME #
#########################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Removing domain from the \"/etc/hosts\" list...\n";
fi

hosts_data=$(cat "/etc/hosts");

domain_regex="^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)+($domain)$";

hosts_data=$(sed -r "s/$domain_regex/{new-line-workaround}/" <<< $hosts_data); # Prevent Duplicate Lines
hosts_data=$(sed -z "s/{new-line-workaround}\n//g" <<< $hosts_data); # Remove New Line (SED Workaround)

echo "$hosts_data" > "/etc/hosts";

#################################
# STEP 5 - PURGE ROOT DIRECTORY #
#################################

if [ $purge = "yes" ]; then
    
    # Determine Directory.
    
    if [ -z $root_dir ]; then
        root_dir=$(echo "$apache_config" | grep -oPZ "((?<=DocumentRoot))+(.*)" | xargs);
    fi
    
    # Purge Directory.
    
    if [ -d $root_dir ]; then
        
        printf "\n";
        
        read -p "Purge root directory \"$root_dir\"? (y/n) - " -n 1 temp && printf "\n";
        
        if [ $temp = "Y" ] || [ $temp = "y" ]; then
            find $root_dir -mindepth 1 -delete;
        fi
        
    else
        
        printf -- "- Root directory purging has been skipped as the directory doesn't exist.\n";
        
    fi
    
fi

###########################
# STEP 6 - RESTART APACHE #
###########################

if [ $verbose_mode = "yes" ]; then
    printf -- "- Restarting apache...\n";
fi

service apache2 restart;
