#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script Version: 1.1.0                                           #
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

domain_regex="^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)+(.*)$";
raw_data="";

###################
# OTHER VARIABLES #
###################

loop_index=0;
temp="";
domains_array=();
addresses_array=();

########################
# STEP 1 - GATHER DATA #
########################

# Get Data.

raw_data=$(cat "/etc/hosts");

# Parse Domains.

domains_array=$(grep "^127." <<< $raw_data | sed -r "s/^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)//g");

readarray domains_array <<< $domains_array;

# Parse Addresses.

addresses_array=$(grep "^127." <<< $raw_data | sed -r "s/(\t)+(.*)$//g");

readarray addresses_array <<< $addresses_array;

#######################
# STEP 2 - PRINT DATA #
#######################

echo -e "Available local domains are:";
echo -e;

for loop_index in "${!domains_array[@]}"
do
    domains_array[$loop_index]=$(echo ${domains_array[loop_index]} | sed -r "s/\n//g");
    addresses_array[$loop_index]=$(echo ${addresses_array[loop_index]} | sed -r "s/\n//g");
    
    echo -e "$(($loop_index + 1)). ${domains_array[loop_index]} - ${addresses_array[loop_index]}";
done

exit;
