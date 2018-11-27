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

# Checks if the user running the script has root privileges.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return integer
#   Value <i>1</i> if the user has root privileges, and vice versa.

function is_root_user()
{
    # Logic.
    
    [[ "$(id -u)" == "0" ]] && return 1;
    
    return 0;
}

# Checks if the domain is valid.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $domain
#   Domain that should be checked.
# @return integer
#   Value <i>1</i> if the domain is valid, and vice versa.

function is_valid_domain()
{
    # Core Variables.
    
    domain=$1;
    probe="";
    
    # Logic.
    
    probe=$(echo $domain | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)');
    
    [[ -z $probe ]] && return 0;
    
    return 1;
}

# Checks if the email address is valid.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $email_address
#   Email address that should be checked.
# @return integer
#   Value <i>1</i> if the email address is valid, and vice versa.

function is_valid_email_address()
{
    # Core Variables.
    
    email_address=$1;
    probe="";
    
    # Logic.
    
    probe=$(echo $email_address | grep -P "^([A-Za-z0-9._%+-])+(@)+([A-Za-z0-9.-])+$");
    
    [[ -z $probe ]] && return 0;
    
    return 1;
}

# Checks if the IP address is valid.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $ip_address
#   IP address that should be checked.
# @return integer
#   Value <i>1</i> if the IP address is valid, and vice versa.

function is_valid_ip_address()
{
    # Core Variables.
    
    ip_address=$1;
    probe="";
    
    # Logic.
    
    probe=$(echo $ip_address | grep -P "^(127\.)+([0-9]{1,3}\.)+([0-9]{1,3}\.)+([0-9]{1,3})$");
    
    [[ -z $probe ]] && return 0;
    
    return 1;
}

# Checks if the directory is valid.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $directory
#   Directory that should be checked.
# @return integer
#   Value <i>1</i> if the directory is valid, and vice versa.

function is_valid_directory()
{
    # Core Variables.
    
    directory=$1;
    
    # Logic.
    
    [[ -d $directory ]] && return 1;
    
    return 0;
}

# Checks if the file is valid.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $file
#   File that should be checked.
# @return integer
#   Value <i>1</i> if the file is valid, and vice versa.

function is_valid_file()
{
    # Core Variables.
    
    file=$1;
    
    # Logic.
    
    [[ -f $file ]] && return 1;
    
    return 0;
}
