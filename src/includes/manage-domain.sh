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

available_domains="";
domain_index=0;

########################
# STEP 1 - SELECT MODE #
########################

if [ -z $mode ]; then
    
    # Print Title.
    
    printf -- "- Do you want to add or remove a domain?\n\n";
    
    # Print Options.
    
    printf "1. Add\n";
    printf "2. Remove\n\n";
    
    # Process Input.
    
    while [ -z $mode ]; do
        
        read -p "Option (1/2) - " -n 1 temp && printf "\n";
        
        if [ $temp = "1" ]; then
            
            mode="add";
            
        elif [ $temp = "2" ]; then
            
            mode="remove";
            
        else
            
            printf "\nInvalid option selected.\n";
            
        fi
        
    done;
    
    echo -e;
    
fi

###################################
# STEP 2 - ENTER OR SELECT DOMAIN #
###################################

if [ -z $domain ]; then
    
    # Enter Domain For Mode "Add"
    
    if [ $mode = "add" ]; then
        
        # Print Title.
        
        printf -- "- Please enter a domain that you want to use.\n";
        
        # Process Input.
        
        while [ -z $domain ]; do
            
            read -p "Domain (ex. www.my-domain.com) - " temp && printf "\n";
            
            if [ $(is_valid_domain $temp; echo $?) -eq 1 ]; then
                
                domain=$temp;
                
            else
                
                printf "Invalid domain provided.\n";
                
            fi
            
        done;
        
    fi
    
    # Select Domain For Mode "Remove"
    
    if [ $mode = "remove" ]; then
        
        # Print Title.
        
        printf -- "- Please select domain you want removed.\n";
        
        # Print Domains.
        
        available_domains=$(cat "/etc/hosts" | grep "^127." | sed -r "s/^(127.)+([0-9]{1,3}.)+([0-9]{1,3}.)+([0-9]{1,3})+(\t)//g");
        
        readarray available_domains <<< $available_domains;
        
        for domain_index in "${!available_domains[@]}"
        do
            available_domains[$domain_index]=$(echo ${available_domains[domain_index]} | sed -r "s/\n//g");
            
            echo "$(($domain_index + 1)). ${available_domains[domain_index]}";
        done
        
        echo -e;
        
        # Process Input.
        
        while [ -z $domain ]; do
            
            read -p "Domain index - " temp && printf "\n";
            
            temp=$(($temp - 1));
            
            if [ -z ${available_domains[temp]} ]; then
                
                printf "Invalid domain provided.\n";
                
            else
                
                domain=${available_domains[temp]};
                
            fi
            
        done;
        
    fi
    
fi

#######################
# STEP 3 - IP ADDRESS #
#######################

if [ -z $ip_address ] && [ $mode == "add" ]; then
    
    # Print Title.
    
    printf -- "- Please enter an IP address that you want to use, or press enter to use the default value.\n";
    
    # Process Input.
    
    while [ -z $ip_address ]; do
        
        read -p "IP address (ex. 127.0.0.1) - " temp && printf "\n";
        
        if [ -z $temp ]; then
            
            ip_address="127.0.0.1";
            
        elif [ $(is_valid_ip_address $temp; echo $?) -eq 1 ]; then
            
            ip_address=$temp;
            
        else
            
            printf "Invalid IP address provided.\n";
            
        fi
        
    done;
    
fi

###########################
# STEP 4 - ROOT DIRECTORY #
###########################

if [ -z $root_dir ] && [ $mode == "add" ]; then
    
    # Print Title.
    
    printf -- "- Please enter a root directory that you want to use, or press enter to use the default value.\n";
    
    # Process Input.
    
    while [ -z $root_dir ]; do
        
        read -p "Root directory (ex. /var/www/html) - " temp && printf "\n";
        
        if [ -z $temp ]; then
            
            root_dir="/var/www/html";
            
        elif [ $(is_valid_directory $temp; echo $?) -eq 1 ]; then
            
            root_dir=$temp;
            
        else
            
            printf "Invalid root directory provided. It doesn't exist.\n";
            
        fi
        
    done;
    
fi

#########################
# STEP 5 - SERVER ADMIN #
#########################

if [ -z $server_admin ] && [ $mode == "add" ]; then
    
    # Print Title.
    
    printf -- "- Please enter an email address for server admin, or press enter to use the default value.\n";
    
    # Process Input.
    
    while [ -z $server_admin ]; do
        
        read -p "Server admin (ex. admin@my-domain.com) - " temp && printf "\n";
        
        if [ -z $temp ]; then
            
            server_admin="webmaster@localhost";
            
        elif [ $(is_valid_email_address $temp; echo $?) -eq 1 ]; then
            
            server_admin=$temp;
            
        else
            
            printf "Invalid email address for server admin provided.\n";
            
        fi
        
    done;
    
fi

################
# STEP 6 - SSL #
################

if [ -z $enable_ssl ] && [ $mode == "add" ]; then
    
    # Print Title.
    
    printf -- "- Do you want to enable SSL?\n";
    
    # Process Input.
    
    while [ -z $enable_ssl ]; do
        
        read -p "Enable SSL (y/n) - " -n 1 temp && printf "\n";
        
        if [ $temp = "Y" ] || [ $temp = "y" ]; then
            
            enable_ssl="yes";
            
        elif [ $temp = "N" ] || [ $temp = "n" ]; then
            
            enable_ssl="no";
            
        else
            
            printf "Invalid option selected.\n";
            
        fi
        
    done;
    
    echo -e;
    
fi

############################
# STEP 7- CERTIFICATE FILE #
############################

if [ -z $cert_file ] && [ $mode = "add" ] && [ $enable_ssl = "yes" ]; then
    
    # Print Title.
    
    printf -- "- Please enter a path of your certificate file, or press enter to use the default value?\n";
    
    # Process Input.
    
    while [ -z $cert_file ]; do
        
        read -p "Certification file (ex. /etc/apache2/ssl/dummy-ssl.crt) - " temp && printf "\n";
        
        if [ -z $temp ]; then
            
            cert_file="$source_dir/templates/dummy-cert.crt";
            
        elif [ $(is_valid_file $temp; echo $?) -eq 1 ]; then
            
            cert_file=$temp;
            
        else
            
            printf "Invalid ceritfication file provided. It doesn't exist.\n";
            
        fi
        
    done;
    
fi

############################
# STEP 8 - CERTIFICATE KEY #
############################

if [ -z $cert_key ] && [ $mode = "add" ] && [ $enable_ssl = "yes" ]; then
    
    # Print Title.
    
    printf -- "- Please enter a path of your certificate key, or press enter to use the default value?\n";
    
    # Process Input.
    
    while [ -z $cert_key ]; do
        
        read -p "Certification key (ex. /etc/apache2/ssl/dummy-ssl.key) - " temp && printf "\n";
        
        if [ -z $temp ]; then
            
            cert_key="$source_dir/templates/dummy-cert.key";
            
        elif [ $(is_valid_file $temp; echo $?) -eq 1 ]; then
            
            cert_key=$temp;
            
        else
            
            printf "Invalid ceritfication key provided. It doesn't exist.\n";
            
        fi
        
    done;
    
fi

##################
# STEP 9 - PURGE #
##################

if [ -z $purge ]; then
    
    # Print Title.
    
    printf -- "- Do you want to purge root directory of a domain?\n";
    
    # Process Input.
    
    while [ -z $purge ]; do
        
        read -p "Purge root directory (y/n) - " -n 1 temp && printf "\n";
        
        if [ $temp = "Y" ] || [ $temp = "y" ]; then
            
            purge="yes";
            
        elif [ $temp = "N" ] || [ $temp = "n" ]; then
            
            purge="no";
            
        else
            
            printf "Invalid option selected.\n";
            
        fi
        
    done;
    
    echo -e;
    
fi

##########################
# STEP 10 - VERBOSE MODE #
##########################

if [ -z $verbose_mode ]; then
    
    # Print Title.
    
    printf -- "- Do you want to enable verbose mode?\n";
    
    # Process Input.
    
    while [ -z $verbose_mode ]; do
        
        read -p "Enable verbose mode (y/n) - " -n 1 temp && printf "\n";
        
        if [ $temp = "Y" ] || [ $temp = "y" ]; then
            
            verbose_mode="yes";
            
        elif [ $temp = "N" ] || [ $temp = "n" ]; then
            
            verbose_mode="no";
            
        else
            
            printf "Invalid option selected.\n";
            
        fi
        
    done;
    
    echo -e;
    
fi
