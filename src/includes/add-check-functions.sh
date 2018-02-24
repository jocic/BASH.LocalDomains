#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script Version: 1.1.1                                           #
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

function is_root_user()
{
    # Logic.
    
    [[ "$(id -u)" == "0" ]] && return 1;
    
    return 0;
}

function is_valid_domain()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    temp=$(echo $1 | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)');
    
    [[ -z $temp ]] && return 0;
    
    return 1;
}

function is_valid_email_address()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    temp=$(echo $1 | grep -P "^([A-Za-z0-9._%+-])+(@)+([A-Za-z0-9.-])+$");
    
    [[ -z $temp ]] && return 0;
    
    return 1;
}

function is_valid_ip_address()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    temp=$(echo $1 | grep -P "^(127\.)+([0-9]{1,3}\.)+([0-9]{1,3}\.)+([0-9]{1,3})$");
    
    [[ -z $temp ]] && return 0;
    
    return 1;
}

function is_valid_directory()
{
    # Logic.
    
    [[ -d $1 ]] && return 1;
    
    return 0;
}

function is_valid_file()
{
    # Logic.
    
    [[ -f $1 ]] && return 1;
    
    return 0;
}
