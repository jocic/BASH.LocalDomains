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

#########
# LOGIC #
#########

function is_root_user()
{
    # Logic.
    
    if [[ "$(id -u)" == "0" ]]; then
        echo "yes";
    else
        echo "no";
    fi
}

function is_valid_domain()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    temp=$(echo $1 | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)');
    
    if [[ -z $temp ]]; then
        echo "no";
    else
        echo "yes";
    fi
}

function is_valid_email_address()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    temp=$(echo $1 | grep -P "^([A-Za-z0-9._%+-])+(@)+([A-Za-z0-9.-])+$");
    
    if [[ -z $temp ]]; then
        echo "no";
    else
        echo "yes";
    fi
}

function is_valid_ip_address()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    temp=$(echo $1 | grep -P "^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})$");
    
    if [[ -z $temp ]]; then
        echo "no";
    else
        echo "yes";
    fi
}

function is_valid_directory()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    if [[ -d $1 ]]; then
        echo "yes";
    else
        echo "no";
    fi
}

function is_valid_file()
{
    # Core Variables.
    
    temp="";
    
    # Logic.
    
    if [[ -f $1 ]]; then
        echo "yes";
    else
        echo "no";
    fi
}
