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
    no_colour="\033[0m"
    updater_time=$(date +'%r')

    if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
        echo "[INFO][$updater_time] Attempting to run the script updater!" >> "$updater_logs_location"
    fi

    if [ -x "$(command -v curl)" ]; then

        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
            echo "[INFO][$updater_time] Curl is installed, downloading updater check files!" >> "$updater_logs_location"
        fi
        curl -o  "$dir/.mrmagicpie_updater_temp_check.txt" "$remote_update_check"
        check_message=$(awk '{if(NR==1) print $0}' ".mrmagicpie_updater_temp_check.txt")
        version=$(awk '{if(NR==3) print $0}' ".mrmagicpie_updater_temp_check.txt")
        type=$(awk '{if(NR==2) print $0}' ".mrmagicpie_updater_temp_check.txt")
        if [ "$check_message" = "$remote_update_check_message" ]; then

            if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                echo "[INFO][$updater_time] An update has been indicated, checking for config suitability!" >> "$updater_logs_location"
            fi
            if [ "$updater_version" = "$updater_version_config" ] && [ "$updater_config_version" = "$updater_config_version_config" ]; then

                if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                    echo "[INFO][$updater_time] Config checks passed!" >> "$updater_logs_location"
                    echo "[INFO][$updater_time] Update available!"  >> "$updater_logs_location"
                fi

                echo " "
                echo "There is an update for $resource!"
                echo "Would you like to update?"
                echo " "
                read -t 25 -p "This will timeout in 25 seconds! (y/n) " maybe_later

                if [ "$maybe_later" = "y" ] || [ "$maybe_later" = "Y" ]; then
                    if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                        echo "[INFO][$updater_time] User has accepted the update!" >> "$updater_logs_location"
                    fi
                    if [ "$fancy_checks" = "y" ] || [ "$fancy_checks" = "Y" ] || [ "$fancy_checks" = "yes" ]; then
                        remote_update_pull="$fancy_checks_pull"
                        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                            echo "[INFO][$updater_time] Fancy checks are enabled! Using version number based updates!" >> "$updater_logs_location"
                        fi
                    fi
                    if [ "$type" = "1" ]; then
                        # This is a general type of update, download the necessary files, and warn the users of the update
                        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                            echo "[INFO][$updater_time] Type 1 has been indicated! Begining update" >> "$updater_logs_location"
                        fi

                    elif [ "$type" = "2" ]; then
                        # This is the replacement type, download necessary files, warn the user of new version, move the files so new update is present
                        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                            echo "[INFO][$updater_time] Type 2 has been indicated! Begining update" >> "$updater_logs_location"
                        fi
                        if ! [ -f "$dir/old-$0" ]; then
                            mv "$dir/$0" "$dir/old-$0"
                        else
                            mv "$dir/$0" "$dir/$updater_time-$0"
                        fi
                        echo " "
                        echo "A type 2 update has been indicated! This means the script will update itself! This is madated by your developer!"
                        echo " "
                        echo "Would you like to restart the script now or restart it on the next script start?"
                        echo " "
                        read -t 25 -p "Restart the script now? (y/n) " two_maybe

                        if [ "$two_maybe" = "y" ] || [ "$two_maybe" = "Y" ] | [ "$two_maybe" = "yes" ]; then
                            if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                                echo "[INFO][$updater_time] Ending the script!" >> "$updater_logs_location"
                            fi
                            echo " "
                            echo -e "Ending this script! Use$red bash $0$no_colour to restart!"
                            echo " "
                            exit

                    elif [ "$type" = "3" ]; then
                        # This is the last update type, download an updater and execute the update!
                        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                            echo "[INFO][$updater_time] Type 3 has been indicated! Begining update" >> "$updater_logs_location"
                        fi

                    else
                        # This is a catch-all for all non-defined options
                        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                            echo -e "$red[FATAL][$updater_time] No type has been specified, exiting update!$no_colour" >> "$updater_logs_location"
                fi; fi; fi
                #         fi
                #     fi
                # fi
            else
                echo " "
                echo "There is an update available for $resource!"
                echo " "
                echo "Unfortunetly you cannot install it because your updater"
                echo "is not configured correctly! If you are not the dev of"
                echo "this script please contact the developer!"
                echo " "
                if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
                    echo -e "$red[FATAL][$updater_time] Your config/updater is not configured properly!$no_colour" >> "$updater_logs_location"
                    echo -e "$red[FATAL][$updater_time] Talk to your developer! Or reach out on GitHub!$no_colour" >> "$updater_logs_location"
                    echo -e "$red[FATAL][$updater_time]     https://github.com/Mrmagicpie/Bash$no_colour" >> "$updater_logs_location"
                fi
            fi
        fi

        rm "$dir/.mrmagicpie_updater_temp_check.txt"

    else

        echo " "
        echo -e "$red[FATAL] Curl must be installed to use the updater!$no_colour"
        echo " "
        if [ "$updater_logs" = "y" ] || [ "$updater_logs" = "Y" ]; then
            echo -e "$red[FATAL][$updater_time] Your config/updater is not configured properly!$no_colour" >> "$updater_logs_location"
        fi
    fi
fi
