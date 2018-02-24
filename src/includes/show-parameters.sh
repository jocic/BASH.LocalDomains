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

if [[ $mode == "add" ]]; then
    
    echo "Domain:          $domain";
    echo "IP Address:      $ip_address";
    echo "Root Dir:        $root_dir";
    echo "Server Admin:    $server_admin";
    echo "Mode:            $mode";
    echo "Enable SSL:      $enable_ssl";
    
    if [[ $enable_ssl == "yes" ]]; then
        
        echo "Cert. File:      $cert_file";
        echo "Cert. Key:       $cert_key";
        
    fi
    
    echo "Verbose Mode:    $verbose_mode";
    
else
    
    echo "Domain:          $domain";
    echo "Mode:            $mode";
    echo "Verbose Mode:    $verbose_mode";
    
fi
