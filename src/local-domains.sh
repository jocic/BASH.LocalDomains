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

user_id=$(id -u);
source_dir="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"
version="1.1.3";

#######################
# PARAMETER VARIABLES #
#######################

domain="";
ip_address="";
mode="";
root_dir="";
cert_file="";
cert_key="";
server_admin="";
enable_ssl="";
purge="";
verbose_mode="";
interactive_mode="no";
list_domains="no";
display_help="no";
display_version="no";

###################
# OTHER VARIABLES #
###################

temp="";

#########
# LOGIC #
#########

source "$source_dir/includes/functions/core.sh";
source "$source_dir/includes/functions/check.sh";
source "$source_dir/includes/functions/domain.sh";

source "$source_dir/includes/check-dependencies.sh";
source "$source_dir/includes/process-parameters.sh";

if [[ "$display_help" == "yes" ]]; then
    
    show_help;
    
elif [[ "$display_version" == "yes" ]]; then
    
    show_version;
    
elif [[ "$list_domains" == "yes" ]]; then
    
    list_domains;
    
else
    
    ##############################
    # STEP 1 - CHECK PRICILEDGES #
    ##############################
    
    if is_root_user; then
        echo -e "Error: Local Domains must be ran with root priviledges." && exit;
    fi
    
    #############################################
    # STEP 2 - GATHER OR SET DEFAULT PARAMETERS #
    #############################################
    
    if [[ "$interactive_mode" == "yes" ]]; then
        
        source "$source_dir/includes/manage-domain.sh";
        
    else
        
        [[ -z "$ip_address" ]] && ip_address="127.0.0.1";
        
        [[ -z "$root_dir" ]] && root_dir="/var/www/html";
        
        [[ -z "$server_admin" ]] && server_admin="webmaster@localhost";
        
        [[ -z "$enable_ssl" ]] && enable_ssl="no";
        
        [[ -z "$cert_file" ]] && cert_file="$source_dir/templates/dummy-cert.crt";
        
        [[ -z "$cert_key" ]] && cert_key="$source_dir/templates/dummy-cert.key";
        
        [[ -z "$purge" ]] && purge="no";
        
        [[ -z "$verbose_mode" ]] && verbose_mode="no";
        
    fi
    
    #############################
    # STEP 3 - CHECK PARAMETERS #
    #############################
    
    # Check Mode.
    
    if [[ -z "$mode" ]]; then
        echo -e "Error: You haven't selected a mode." && exit;
    fi
    
    # Check Domain.
    
    if [[ $(is_valid_domain "$domain"; echo $?) -eq 0 ]]; then
        echo -e "Error: Invalid domain name provided." && exit;
    fi
    
    # Check IP Address.
    
    if [[ "$mode" == "add" ]] && [[ $(is_valid_ip_address "$ip_address"; echo $?) -eq 0 ]]; then
        echo -e "Error: Invalid IP address provided." && exit;
    fi
    
    # Check Root Directory.
    
    if [[ "$mode" == "add" ]] && [[ $(is_valid_directory "$root_dir"; echo $?) -eq 0 ]]; then
        echo -e "Error: Invalid root directory provided. It doesn't exist." && exit;
    fi
    
    # Check Server Admin.
    
    if [[ "$mode" == "add" ]] && [[ $(is_valid_email_address "$server_admin"; echo $?) -eq 0 ]]; then
        echo -e "Error: Invalid email address for server admin provided." && exit;
    fi
    
    # Check Certificate File & Key.
    
    if [[ "$enable_ssl" == "yes" ]]; then
        
        # File.
        
        if [[ $(is_valid_file "$cert_file"; echo $?) -eq 0 ]]; then
            echo -e "Error: Invalid ceritfication file provided. It doesn't exist." && exit;
        fi
        
        # Key.
        
        if [[ $(is_valid_file "$cert_key"; echo $?) -eq 0 ]]; then
            echo -e "Error: Invalid ceritfication key provided. It doesn't exist." && exit;
        fi
        
    fi
    
    ###########################
    # STEP 4 - PROCESS DOMAIN #
    ###########################
    
    # Show Parameters.
    
    source "$source_dir/includes/show-parameters.sh";
    
    # Print Title.
    
    echo -e "\nPlease review parameters above before proceeding.\n";
    
    # Process Input.
    
    while true;
    do
        read -p "Continue? (y/n) - " -n 1 temp;
        echo -e;
        
        if [[ "$temp" =~ ^[Yy]$ ]]; then
            
            if [[ "$mode" == "add" ]]; then
                source "$source_dir/includes/add-domain.sh";
            elif [[ "$mode" == "remove" ]]; then
                source "$source_dir/includes/remove-domain.sh";
            else
                echo -e "Invalid mode selected.";
            fi
            
            exit;
            
        elif [[ "$temp" =~ ^[Nn]$ ]]; then
            
            echo -e "\nExiting..." && exit;
            
        else
            
            echo -e "\nInvalid option selected.\n";
            
        fi
    done
    
fi
