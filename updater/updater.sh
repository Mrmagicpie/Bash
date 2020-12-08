#!/bin/bash
#!/root/version_1

#
# The Mrmagicpie Updater
#
# This is a "simple" bash updater which is fully customizable!
#
# Report issues here:
# https://github.com/Mrmagicpie/Bash
#

config_location="$dir/config.mrmagicpie.sh"
# Location of your config. The default option
# is "$dir/config.mrmagicpie.sh". "$dir" = current 
# file path!

# Coding time! :D

# # # # # # # # # # # # # # # # # # # # # # # 

updater_version="1"
updater_config_version="1"
dir=$(pwd)

. "$config_location"

if [ "$updater_enabled" = "y" ] || [ "$updater_enabled" = "yes" ] || [ "$updater_enabled" = "Y" ]; then

    red="\033[0;31m"
    no_colour="!\033[0m"

    if [ -x "$(command -v curl)" ]; then
        curl -o  "$dir/.mrmagicpie_updater_temp_check.txt" "$remote_update_check"
        check_message=$(awk '{if(NR==1) print $0}' ".mrmagicpie_updater_temp_check.txt")
        version=$(awk '{if(NR==3) print $0}' ".mrmagicpie_updater_temp_check.txt")
        type=$(awk '{if(NR==2) print $0}' ".mrmagicpie_updater_temp_check.txt")
        if [ "$check_message" = "$remote_update_check_message" ]; then
            if [ "$fancy_checks" = "y" ] || [ "$fancy_checks" = "Y" ] || [ "$fancy_checks" = "yes" ]; then
                remote_update_pull="$fancy_checks_pull"
            fi
            if [ "$type" = "1" ]; then
                # This is a general type of update, download the necessary files, and warn the users of the update

            elif [ "$type" = "2" ]; then
                # This is the replacement type, download necessary files, warn the user of new version, move the files so new update is present

            elif [ "$type" = "3" ]; then
                # This is the last update type, download an updater and execute the update!

            else
                # This is a catch-all for all non-defined options

            fi

        fi

        rm "$dir/.mrmagicpie_updater_temp_check.txt"


    else

        echo " "
        echo -e "$red[FATAL] Curl must be installed to use the updater!$no_colour"
        echo " "

    fi
fi
