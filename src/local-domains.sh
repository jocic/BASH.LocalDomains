#!/bin/bash

##################################################
# Script Author: Djordje Jocic                   #
# Script Year: 2018                              #
# Script Version: 1.0.0                          #
# Script License: MIT License (MIT)              #
# ============================================== #
# Personal Website: http://www.djordjejocic.com/ #
# ============================================== #
# Permission is hereby granted, free of charge,  #
# to any person obtaining a copy of this         #
# software and associated documentation files    #
# (the "Software"), to deal in the Software      #
# without restriction, including without         #
# limitation the rights to use, copy, modify,    #
# merge, publish, distribute, sublicense, and/or #
# sell copies of the Software, and to permit     #
# persons to whom the Software is furnished to   #
# do so, subject to the following conditions:    #
# ---------------------------------------------- #
# The above copyright notice and this permission #
# notice shall be included in all copies or      #
# substantial portions of the Software.          #
# ---------------------------------------------- #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT      #
# WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,      #
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR      #
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL #
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR #
# ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER #
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   #
# RISING FROM, OUT OF OR IN CONNECTION WITH THE  #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE   #
# SOFTWARE.                                      #
##################################################

##################
# CORE VARIABLES #
##################

version="1.0.0";

###################
# OTHER VARIABLES #
###################

temp=""

#########
# LOGIC #
#########

source "./includes/process-parameters.sh";

if [ $display_help == "yes" ]; then
    
    source "./includes/show-help.sh";
    
elif [ $display_version == "yes" ]; then
    
    source "./includes/show-version.sh";
    
else
    
    ##############################
    # STEP 1 - CHECK DOMAIN NAME #
    ##############################
    
    temp=$(echo $domain | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)');
    
    if [ -z $temp ]; then
        
        echo "Error: Invalid domain name provided.";
        
        exit;
        
    fi
    
    #################################
    # STEP 2 - ASK FOR CONFIRMATION #
    #################################
    
    source "./includes/show-parameters.sh";
    
    echo -e "\nPlease review parameters above before proceeding.\n";
    
    read -p "Continue? (y/n)" -n 1 -r;
    
    ###########################
    # STEP 2 - PROCESS DOMAIN #
    ###########################
    
    echo -e "\n";
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        
        echo -e "Adding...";
        
    else
        
        echo -e "Exiting...";
        
        exit;
        
    fi
    
fi
