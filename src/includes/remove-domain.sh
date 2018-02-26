#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script Version: 1.1.2                                           #
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

if [[ $verbose_mode == "yes" ]]; then
    echo -e "- Generating filename prefix for necessary files...";
fi

filename_prefix="${domain//$filename_prefix_pattern/_}";

#######################################
# STEP 2 - REMOVE CONFIGURATION FILES #
#######################################

if [[ $verbose_mode == "yes" ]]; then
    echo -e "- Removing configuration files...";
fi

if [[ -f "/etc/apache2/sites-available/$filename_prefix.conf" ]]; then
    rm "/etc/apache2/sites-available/$filename_prefix.conf";
fi

if [[ -f "/etc/apache2/sites-enabled/$filename_prefix.conf" ]]; then
    rm "/etc/apache2/sites-enabled/$filename_prefix.conf";
fi

#####################################
# STEP 3 - REMOVE CERTIFICATE FILES #
#####################################

if [[ $verbose_mode == "yes" ]]; then
    echo -e "- Removing certificate files...";
fi
echo "/etc/apache2/ssl/$filename_prefix.crt";
if [[ -f "/etc/apache2/ssl/$filename_prefix.crt" ]]; then
    rm "/etc/apache2/ssl/$filename_prefix.crt";
fi

if [[ -f "/etc/apache2/ssl/$filename_prefix.key" ]]; then
    rm "/etc/apache2/ssl/$filename_prefix.key";
fi

#########################
# STEP 4 - ADD HOSTNAME #
#########################

if [[ $verbose_mode == "yes" ]]; then
    echo -e "- Removing domain from the \"/etc/hosts\" list...";
fi

hosts_data=$(cat "/etc/hosts");

domain_regex="^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)+($domain)$";

hosts_data=$(sed -r "s/$domain_regex/{new-line-workaround}/" <<< $hosts_data); # Prevent Duplicate Lines
hosts_data=$(sed -z "s/{new-line-workaround}\n//g" <<< $hosts_data); # Remove New Line (SED Workaround)

echo "$hosts_data" > "/etc/hosts";

###########################
# STEP 5 - RESTART APACHE #
###########################

if [[ $verbose_mode == "yes" ]]; then
    echo -e "- Restarting apache...";
fi

service apache2 restart;
