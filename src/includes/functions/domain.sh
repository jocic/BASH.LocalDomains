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

#########
# LOGIC #
#########

# Prints project's version.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

list_domains()
{
    # Core Variables
    
    domain_regex="^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)+(.*)$";
    raw_data="";
    
    # Other Variables
    
    loop_index=0;
    temp="";
    domains_array="";
    addresses_array="";
    
    # Step 1 - Get Raw Data
    
    raw_data=$(cat "/etc/hosts");
    
    # Step 2 - Get Domains
    
    domains_array=$(echo "$raw_data" | grep "^127." | sed -r "s/^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)//g");
    
    #readarray domains_array <<< $domains_array;
    
    # Step 3 - Get Addresses
    
    addresses_array=$(echo "$raw_data" | grep "^127." | sed -r "s/(\t)+(.*)$//g");
    
    #readarray addresses_array <<< $addresses_array;
    
    # Step 4 - Print Data
    
    printf "Available local domains are:\n\n";
    
    for address in $addresses_array; do
        
        loop_index=$(( loop_index + 1 ));
        
        domain=$(echo "$domains_array" | sed -n "${loop_index}p");
        ip_address=$(echo "$addresses_array" | sed -n "${loop_index}p");
        
        echo "$loop_index. $domain - $ip_address";
        
    done
}
