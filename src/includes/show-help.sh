#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
# Script Version: 1.1.2                                           #
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

########################################
# STEP 1 - DISPLAY BASIC USAGE EXAMPLE #
########################################

echo -e "Usage: local-domains -d {domain} {parameters}\n";

echo -e "Adds a local domain and restarts apache.\n";

###################################
# STEP 2 - DISPLAY PARAMETER HELP #
###################################

echo "  -d {domain}, --domain {domain}                       Domain that needs to be added or removed.";
echo "  -ip {ip_address}, --ip-address {ip_address}          IP address that should be assigned to the domains.";
echo "  -rd {root_dir}, --root-dir {root_dir}                Root directory of a domain.";
echo "  -sa {server_admin}, --server-admin {server_admin}    Server admin's email address";
echo "  -cf {cert_file}, --cert-file {cert_file}             Certificate file location.";
echo "  -ck {cert_key}, --cert-key {cert_key}                Certificate key location.";
echo "  -a, --add                                            Select add mode.";
echo "  -r, --remove                                         Select remove mode.";
echo "  -s, --ssl                                            Enable SSL.";
echo "  -i, --interactive                                    Select interactive mode.";
echo "  -v, --verbose                                        Explain what is being done.";
echo "  -l, --list                                           Lists all available domains.";
echo "  -h, --help                                           Display this help and exit.";
echo "      --version                                        Output version information and exit.";

exit;
