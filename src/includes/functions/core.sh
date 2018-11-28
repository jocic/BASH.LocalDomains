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

# Parses provided value for use in single quotes.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param string $value
#   Value that should be parsed.
# @return void

parse_value()
{
    # Core Variables
    
    value=$1;
    
    # Logic
    
    printf "%s" $value | sed -e "s/'/'\\\''/g";
}

# Processes passed script arguments.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @param array $args
#   Arguments that should be processed.
# @return void

process_arguments()
{
    # Control Variables
    
    queue="";
    
    # Logic
    
    for arg in "$@"; do
        
        # Assign Queued Values
        
        if [ "$queue" = "domain" ]; then
            domain=$param_value;
        elif [ "$queue" = "ip-address" ]; then
            ip_address=$param_value;
        elif [ "$queue" = "root-dir" ]; then
            root_dir=$param_value;
        elif [ "$queue" = "server-admin" ]; then
            server_admin=$param_value;
        elif [ "$queue" = "cert-file" ]; then
            cert_file=$param_value;
        elif [ "$queue" = "cert-key" ]; then
            cert_key=$param_value;
        fi
        
        # Reset Queue Value
        
        queue="";
        
        # Queue Commands
        
        if [ "$arg" = "-d" ] || [ "$arg" = "--domain" ]; then
            queue="domain";
        elif [ "$arg" = "-ip" ] || [ "$arg" = "--ip-address" ]; then
            queue="ip";
        elif [ "$arg" = "-rd" ] || [ "$arg" = "--root-dir" ]; then
            queue="root-dir";
        elif [ "$arg" = "-sa" ] || [ "$arg" = "--server-admin" ]; then
            queue="server-admin";
        elif [ "$arg" = "-cf" ] || [ "$arg" = "--cert-file" ]; then
            queue="cert-file";
        elif [ "$arg" = "-ck" ] || [ "$arg" = "--cert-key" ]; then
            queue="cert-key";
        elif [ "$arg" = "-a" ] || [ "$arg" = "--add" ]; then
            mode="add";
        elif [ "$arg" = "-r" ] || [ "$arg" = "--remove" ]; then
            mode="remove";
        elif [ "$arg" = "-s" ] || [ "$arg" = "--ssl" ]; then
            enable_ssl="yes";
        elif [ "$arg" = "-p" ] || [ "$arg" = "--purge" ]; then
            purge="yes";
        elif [ "$arg" = "-v" ] || [ "$arg" = "--verbose" ]; then
            verbose_mode="yes";
        elif [ "$arg" = "-i" ] || [ "$arg" = "--interactive" ]; then
            interactive_mode="yes";
        elif [ "$arg" = "-l" ] || [ "$arg" = "--list" ]; then
            list_domains="yes";
        elif [ "$arg" = "-h" ] || [ "$arg" = "--help" ]; then
            display_help="yes";
        elif [ "$arg" == "--version" ]; then
            display_version="yes";
        fi
        
    done
}

# Checks dependencies and the potential error message.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

check_dependencies()
{
    # Core Variables
    
    packages=$(echo "sysvinit-utils apache2" | tr " " "\n");
    
    # Logic
    
    for package in $packages; do
        
        if [ "$(dpkg -l | grep "$package")" = "" ]; then
            
            if [ ! -z "$(command -v apt-get)" ]; then
                printf "Error: Command \"%s\" is missing. Please install the dependency by typing \"apt-get install %s\".\n" $package $package;
            elif [ ! -z "$(command -v yum)" ]; then
                printf "Error: Command \"%s\" is missing. Please install the dependency by typing \"yum install %s\".\n" $package $package;
            else
                printf "Error: Command \"%s\" is missing. Please install \"%s\".\n" $package $package;
            fi
            
        fi
        
    done
}

# Prints project's help.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function show_help()
{
    # Logic
    
    cat "$source_dir/other/help.txt" && exit;
}

# Prints project's version.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

function show_version()
{
    # Logic
    
    echo -e "Local Domains $version";
    
    cat "$source_dir/other/version.txt" && exit;
}
