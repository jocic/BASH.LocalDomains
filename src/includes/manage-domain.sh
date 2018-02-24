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

available_domains="";
domain_index=0;

########################
# STEP 1 - SELECT MODE #
########################

if [[ -z $mode ]]; then
    
    # Print Title.
    
    echo -e "- Do you want to add or remove a domain?";
    echo -e;
    
    # Print Options.
    
    echo -e "1. Add";
    echo -e "2. Remove";
    echo -e;
    
    # Process Input.
    
    while [ -z $mode ]
    do
        
        read -p "Option (1/2) - " -n 1 temp;
        echo -e;
        
        if [[ $temp == "1" ]]; then
            
            mode="add";
            
        elif [[ $temp == "2" ]]; then
            
            mode="remove";
            
        else
            
            echo -e;
            echo -e "Invalid option selected.";
            echo -e;
            
        fi
        
    done;
    
    echo -e;
    
fi

###################################
# STEP 2 - ENTER OR SELECT DOMAIN #
###################################

if [[ -z $domain ]]; then
    
    # Enter Domain For Mode "Add"
    
    if [[ $mode == "add" ]]; then
        
        # Print Title.
        
        echo -e "- Please enter a domain that you want to use.";
        echo -e;
        
        # Process Input.
        
        while [[ -z $domain ]]
        do
            
            read -p "Domain (ex. www.my-domain.com) - " temp;
            echo -e;
            
            if [[ $(is_valid_domain $temp) == "yes" ]]; then
                
                domain=$temp;
                
            else
                
                echo -e "Invalid domain provided.";
                echo -e;
                
            fi
            
        done;
        
    fi
    
    # Select Domain For Mode "Remove"
    
    if [[ $mode == "remove" ]]; then
        
        # Print Title.
        
        echo -e "- Please select domain you want removed.";
        echo -e;
        
        # Print Domains
        
        available_domains=$(cat "/etc/hosts" | grep "^127." | sed -r "s/^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)//g");
        
        readarray available_domains <<< $available_domains;
        
        for domain_index in "${!available_domains[@]}"
        do
            available_domains[$domain_index]=$(echo ${available_domains[domain_index]} | sed -r "s/\n//g");
            
            echo "$(($domain_index + 1)). ${available_domains[domain_index]}";
        done
        
        echo -e;
        
        # Process Input.
        
        while [[ -z $domain ]]
        do
            
            read -p "Domain index - " temp;
            echo -e;
            
            temp=$(($temp - 1));
            
            if [[ -z ${available_domains[temp]} ]]; then
                
                echo -e "Invalid domain provided.";
                echo -e;
                
            else
                
                domain=${available_domains[temp]};
                
            fi
            
        done;
        
    fi
    
fi

#######################
# STEP 3 - IP ADDRESS #
#######################

if [[ -z $ip_address ]] && [[ $mode == "add" ]]; then
    
    # Print Title.
    
    echo -e "- Please enter an IP address that you want to use, or press enter to use the default value.";
    echo -e;
    
    # Process Input.
    
    while [[ -z $ip_address ]]
    do
        
        read -p "IP address (ex. 127.0.0.1) - " temp;
        echo -e;
        
        if [[ -z $temp ]]; then
            
            ip_address="127.0.0.1";
            
        elif [[ $(is_valid_ip_address $temp) == "yes" ]]; then
            
            ip_address=$temp;
            
        else
            
            echo -e "Invalid IP address provided.";
            echo -e;
            
        fi
        
    done;
    
fi

###########################
# STEP 4 - ROOT DIRECTORY #
###########################

if [[ -z $root_dir ]] && [[ $mode == "add" ]]; then
    
    # Print Title.
    
    echo -e "- Please enter a root directory that you want to use, or press enter to use the default value.";
    echo -e;
    
    # Process Input.
    
    while [[ -z $root_dir ]]
    do
        
        read -p "Root directory (ex. /var/www/html) - " temp;
        echo -e;
        
        if [[ -z $temp ]]; then
            
            root_dir="/var/www/html";
            
        elif [[ $(is_valid_directory $temp) == "yes" ]]; then
            
            root_dir=$temp;
            
        else
            
            echo -e "Invalid root directory provided. It doesn't exist.";
            echo -e;
            
        fi
        
    done;
    
fi

#########################
# STEP 5 - SERVER ADMIN #
#########################

if [[ -z $server_admin ]] && [[ $mode == "add" ]]; then
    
    # Print Title.
    
    echo -e "- Please enter an email address for server admin, or press enter to use the default value.";
    echo -e;
    
    # Process Input.
    
    while [[ -z $server_admin ]]
    do
        
        read -p "Server admin (ex. admin@my-domain.com) - " temp;
        echo -e;
        
        if [[ -z $temp ]]; then
            
            server_admin="webmaster@localhost";
            
        elif [[ $(is_valid_email_address $temp) == "yes" ]]; then
            
            server_admin=$temp;
            
        else
            
            echo -e "Invalid email address for server admin provided.";
            echo -e;
            
        fi
        
    done;
    
fi

################
# STEP 6 - SSL #
################

if [[ -z $enable_ssl ]] && [[ $mode == "add" ]]; then
    
    # Print Title.
    
    echo -e "- Do you want to enable SSL?";
    echo -e;
    
    # Process Input.
    
    while [[ -z $enable_ssl ]]
    do
        
        read -p "Enable SSL (y/n) - " -n 1 temp;
        echo -e;
        
        if [[ $temp =~ ^[Yy]$ ]]; then
            
            enable_ssl="yes";
            
        elif [[ $temp =~ ^[Nn]$ ]]; then
            
            enable_ssl="no";
            
        else
            
            echo -e;
            echo -e "Invalid option selected.";
            echo -e;
            
        fi
        
    done;
    
    echo -e;
    
fi

############################
# STEP 7- CERTIFICATE FILE #
############################

if [[ -z $cert_file ]] && [[ $mode == "add" ]]; then
    
    # Print Title.
    
    echo -e "- Please enter a path of your certificate file, or press enter to use the default value?";
    echo -e;
    
    # Process Input.
    
    while [[ -z $cert_file ]]
    do
        
        read -p "Certification file (ex. /etc/apache2/ssl/dummy-ssl.crt) - " temp;
        echo -e;
        
        if [[ -z $temp ]]; then
            
            cert_file="/etc/apache2/ssl/dummy-ssl.crt";
            
        elif [[ $(is_valid_file $temp) == "yes" ]]; then
            
            cert_file=$temp;
            
        else
            
            echo -e "Invalid ceritfication file provided. It doesn't exist.";
            echo -e;
            
        fi
        
    done;
    
fi

############################
# STEP 8 - CERTIFICATE KEY #
############################

if [[ -z $cert_key ]] && [[ $mode == "add" ]]; then
    
    # Print Title.
    
    echo -e "- Please enter a path of your certificate key, or press enter to use the default value?";
    echo -e;
    
    # Process Input.
    
    while [[ -z $cert_key ]]
    do
        
        read -p "Certification file (ex. /etc/apache2/ssl/dummy-ssl.crt) - " temp;
        echo -e;
        
        if [[ -z $temp ]]; then
            
            cert_key="/etc/apache2/ssl/dummy-ssl.key";
            
        elif [[ $(is_valid_file $temp) == "yes" ]]; then
            
            cert_key=$temp;
            
        else
            
            echo -e "Invalid ceritfication key provided. It doesn't exist.";
            echo -e;
            
        fi
        
    done;
    
fi

#########################
# STEP 9 - VERBOSE MODE #
#########################

if [[ -z $verbose_mode ]]; then
    
    # Print Title.
    
    echo -e "- Do you want to enable verbose mode?";
    echo -e;
    
    # Process Input.
    
    while [[ -z $verbose_mode ]]
    do
        
        read -p "Enable verbose mode (y/n) - " -n 1 temp;
        echo -e;
        
        if [[ $temp =~ ^[Yy]$ ]]; then
            
            verbose_mode="yes";
            
        elif [[ $temp =~ ^[Nn]$ ]]; then
            
            verbose_mode="no";
            
        else
            
            echo -e;
            echo -e "Invalid option selected.";
            echo -e;
            
        fi
        
    done;
    
    echo -e;
    
fi
