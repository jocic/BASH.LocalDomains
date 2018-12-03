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

#################
# GET FUNCTIONS #
#################

# GET FUNCTIONS GO HERE

#################
# SET FUNCTIONS #
#################

# GET FUNCTIONS GO HERE

##################
# CORE FUNCTIONS #
##################

# Prints project's help.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

show_help()
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

show_version()
{
    # Logic
    
    printf "Local Domains %s\n" "$version";
    
    cat "$source_dir/other/version.txt" && exit;
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
        
        [ "$queue" = "domain" ] && domain=$arg;
        
        [ "$queue" = "ip-address" ] && ip_address=$arg;
        
        [ "$queue" = "root-dir" ] && root_dir=$arg;
        
        [ "$queue" = "server-admin" ] && server_admin=$arg;
        
        [ "$queue" = "cert-file" ] && cert_file=$arg;
        
        [ "$queue" = "cert-key" ] && cert_key=$arg;
        
        # Reset Queue Value
        
        queue="";
        
        # Queue Commands
        
        [ "$arg" = "-d" ] || [ "$arg" = "--domain" ] && queue="domain";
        
        [ "$arg" = "-ip" ] || [ "$arg" = "-e" ] || [ "$arg" = "--ip-address" ] && queue="ip-address";
        
        [ "$arg" = "-rd" ] || [ "$arg" = "-o" ] || [ "$arg" = "--root-dir" ] && queue="root-dir";
        
        [ "$arg" = "-sa" ] || [ "$arg" = "-m" ] || [ "$arg" = "--server-admin" ] && queue="server-admin";
        
        [ "$arg" = "-cf" ] || [ "$arg" = "-f" ] || [ "$arg" = "--cert-file" ] && queue="cert-file";
        
        [ "$arg" = "-ck" ] || [ "$arg" = "-k" ] || [ "$arg" = "--cert-key" ] && queue="cert-key";
        
        [ "$arg" = "-a" ] || [ "$arg" = "--add" ] && mode="add";
        
        [ "$arg" = "-r" ] || [ "$arg" = "--remove" ] && mode="remove";
        
        [ "$arg" = "-s" ] || [ "$arg" = "--ssl" ] && enable_ssl="yes";
        
        [ "$arg" = "-p" ] || [ "$arg" = "--purge" ] && purge="yes";
        
        [ "$arg" = "-v" ] || [ "$arg" = "--verbose" ] && verbose_mode="yes";
        
        [ "$arg" = "-i" ] || [ "$arg" = "--interactive" ] && interactive_mode="yes";
        
        [ "$arg" = "-l" ] || [ "$arg" = "--list" ] && list_domains="yes";
        
        [ "$arg" = "--install" ] && install_deps="yes";
        
        [ "$arg" = "-h" ] || [ "$arg" = "--help" ] && display_help="yes";
        
        [ "$arg" == "--version" ] && display_version="yes";
        
    done
}

# Installs project's dependencies.
# 
# @author: Djordje Jocic <office@djordjejocic.com>
# @copyright: 2018 MIT License (MIT)
# @version: 1.0.0
# 
# @return void

install_dependencies()
{
    # Core Variables
    
    dependencies=$(echo "sysvinit-utils apache2" | tr " " "\n");
    
    # Logic
    
    for dependency in $dependencies; do
        
        if [ ! -z "$(command -v apt-get)" ]; then
            apt-get install $dependency -y;
        elif [ ! -z "$(command -v yum)" ]; then
            yum install $depndency -y;
        else
            printf "Error: Your system isn't supported.\n" && exit;
        fi;
        
    done
}

###################
# CHECK FUNCTIONS #
###################

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

###################
# OTHER FUNCTIONS #
###################

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
