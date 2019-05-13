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

if [ $mode = "add" ]; then
    
    printf "Domain:          %s\n" "$domain";
    printf "IP Address:      %s\n" "$ip_address";
    printf "Root Dir:        %s\n" "$root_dir";
    printf "Server Admin:    %s\n" "$server_admin";
    printf "Purge:           %s\n" "$purge";
    printf "Mode:            %s\n" "$mode";
    printf "Enable SSL:      %s\n" "$enable_ssl";
    
    if [ $enable_ssl = "yes" ]; then
        
        printf "Cert. File:      %s\n" "$cert_file";
        printf "Cert. Key:       %s\n" "$cert_key";
        
    fi
    
    printf "Verbose Mode:    %s\n" "$verbose_mode";
    
else
    
    printf "Domain:          %s\n" "$domain";
    printf "Purge:           %s\n" "$purge";
    printf "Mode:            %s\n" "$mode";
    printf "Verbose Mode:    %s\n" "$verbose_mode";
    
fi
