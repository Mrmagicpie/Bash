#!/bin/bash

#
# Mrmagicpie Importer. This is a bash script importer
# used to import code from other places on your file
# system or via url.
#

#
# This is a per project system. You can change this in your project's ".import" 
# directory!
#

# # # # # # # # # # # # # # # # # # # # # # # # # # #
importer_dir=$(pwd)
importer_red="\033[0;31m"
importer_no_colour="\033[0m"
importer_time=$(date +'%r')
importer_logs="$importer_dir/importer.logs"

import-url(){
    if [[ "$1" =~ http://.* ]] || [[ "$1" =~ https://.* ]]; then
        touch "$importer_logs"
        echo -e "[INFO][$importer_time] Importing $rimporter_ed$1$importer_no_colour via URL!" >> $importer_logs 
        if [ ]
        echo ""
    fi
}
import-url http://lmao

import(){
    placeholder
}