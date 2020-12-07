#!/bin/bash

dir=$(pwd)
time=$(date +'%r')
script_config_version="1"
ssh_attempted="0"

config(){
	# Echo the current config into the config.sh
	echo """#!/bin/bash

#
# Main config file for the "update_ip.sh" script programmed by Mrmagicpie!
#
# https://github.com/Mrmagicpie
#

logs="$(pwd)/logs"
# Do not change this unless you REALLY want to

sysname="Remote"
# Remote System name

ssh_path="~/id_rsa.pub"
# Remote SSH public key
# Due to the nature of this script you can only use public
# key auth. Feel free to modify the SRC but you will have to
# enter your remote server password every hour!

ip_file="/var/www/html/hide_me_better_pls.txt"
# Location on remote server to store most recent IP
# Generally kept in the Apache webroot "/var/www" for easy
# web access. Learn about Apache2 here:
# https://apache.mrmagicpie.xyz

user="root"
# Remote user - indicate if sudo!!

sudo="y"
# Remote user sudo privileges, will only listen to "y"/"n"
# Must be set to "y" if the user does not have privileges
# by default! Be warned, the user must also have sudo on the
# remote server!

server_ip="localhost"
# Remote address

port="22"
# SSH port


     # # # # # # # # # #

     # Advanced Config
     # No need to edit!

     # # # # # # # # # #

repeat_after="3600"
# Time to repeat the main IP update
# Defaults to 1 hour!
# Must be in seconds

ssh_repeat_after="10"
# Time to atempt an SSH connection
# Defaults to 10 seconds!
# Must be in Seconds

ssh_attempts="5"
# Amount of times you want SSH to attempt before
# Ending the script
# Only seconds are valid!

default_log=""
# Default setting for logging
# Available options: "y"/"n"

query_update="y"
# Default and recommended setting for this is "y"
# This will check if there's an available script 
# update, set to "n" if you do not want this!
# Available options: "y"/"n"

     # # # # # # # # # #

     # Do not edit section!

     # # # # # # # # # #

config_verify="Mrmagicpie-IP-Config"
# DO NOT CHANGE THIS
# If you change this setting your config will be marked as invalid

config_version="1"
# Version of your config, this is used when updating the script
# DO NOT EDIT
""" >> "$dir/config.sh"
}

config_help(){

# Config error menu for when the current config is invalid

	echo " "
	echo "Your config has been marked as invalid!" 
	echo "Would you like to:"
	echo "1: Rename/stash your config"
	echo "2: Exit this script"
	echo " "
	read -p "Choose an option(1-2): " config_lmao

	if [ "$config_lmao" = "1" ]; then
		if ! [ -f "$dir/config.old" ]; then
			mv "$dir/config.sh" "$dir/config.old" # Moving old config to "config.old"
		else
			read -p "Please specify a filename for your old config: " config_name # Asking user what they want their config to be renamed to if "config.old" is taken
			mv "$dir/config.sh" "$dir/$config_name"
			touch "$dir/config.sh"
			config
		fi
	elif [ "$config_lmao" = "2" ]; then # Second config option to exit the script
		echo " "
		echo "Exiting"
		echo " "
		sleep 1
		exit
	else # Catching invalid options, and restarting config menu
		echo " "
		echo "Error: Invalid option!"
		echo " "
		sleep 1
		config_help
	fi
}

if ! [ -f "$dir/config.sh" ]; then # Checking if a config file exsists, if not, send to config function to create one
	echo " "
	echo "You have no valid config! Generating new config at $dir/config.sh"
	echo " "
	touch "$dir/config.sh"
	config

else

	. "$dir/config.sh" # Echo-ing the config to check variables
	if [ "$config_verify" != "Mrmagicpie-IP-Config" ]; then # Checking if the config included is a config coded by Mrmagicpie
		echo " "
		echo "Error! You do not have a valid config!"
		echo " "
		sleep 1
		config_help # Sending to invalid config menu

	fi

	if [ "$config_version" != "$script_config_version" ]; then # Checking if the config included is a config intended for this script
		echo " "
		echo "Error! Your config is not the right version for this script!"
		echo " "
		sleep 1
		config_help # Sending to invalid config menu
	fi
fi

. "$dir/config.sh" # Echo-ing the config if all checks passed, used for variables

retry_ssh(){

# The "retry_ssh" function is only executed when the main SSH command has failed it will only have a limited amount of tries, defaults to 5.

# Math section for this funcion
retry=$(expr "$ssh_repeat_after" - 5)
ssh_attempted=$(expr "$ssh_attempted" + 1)
ssh_attempts_oop=$(expr "ssh_attempts" + 1)

if [ "$ssh_attempted" = "$ssh_attempts_oop" ]; then # Checking if max tries has been reached
	echo " "
	echo -e "\033[0;31m[FATAL][$time] SSH has failed too many times!\033[0m"
	echo " "
	if [ "$log" = "y" ]; then # Logging to logs if enabled
		echo -e "\033[0;31m[FATAL][$time] SSH has failed too many times!\033[0m" >> "$logs"
	fi
	sleep 3
	exit
fi

if [ "$log" = "y" ]; then # Logging to logs if enabled
	echo -e "\033[0;31m[WARN][$time] SSH to $sysname has failed.\033[0m" >> "$logs"
	echo -e "\033[0;31m[WARN][$time] Retrying SSH to $sysname in $ssh_retry_after seconds!\033[0m" >> "$logs"
fi

# Visual countdown until the "start" function is called again
echo -e "\033[0;31mSSH failed. Retrying in $ssh_repeat_after seconds\033[0m"
sleep "$retry" # Waiting the amount of time specified in the config, defaults to 10
echo -e "\033[0;31mRetrying in 5\033[0m"
sleep 1
echo -e "\033[0;31mRetrying in 4\033[0m"
sleep 1
echo -e "\033[0;31mRetrying in 3\033[0m"
sleep 1
echo -e "\033[0;31mRetrying in 2\033[0m"
sleep 1
echo -e "\033[0;31mRetrying SSH\033[0m"

if [ "$log" = "y" ]; then # Logging to logs if enabled
	echo -e "\033[0;31m[WARN][$time] Retrying SSH to $sysname\033[0m" >> "$logs"
fi

sleep 1 # Waiting for a seconf to let the user catch up
start

}

start(){

ip=$(curl ifconfig.me) # Curl the Computers current public IP address

echo " "
echo "The current IP is: $ip" # Echo to console the current IP
echo " "

if [ "$log" = "y" ]; then
	echo "[INFO][$time] Current IP is $ip" >> "$logs" # Output to logs, if logs are enable the current IP
fi

sleep 2 # Sleep to prevent the user being overwhelmed

echo " "
echo "Updating $sysname with the IP: $ip" # Stating what IP the remote will be updated with
echo "Today at $time" 					  # And the time it was updated
echo " "

if [ "$log" = "y" ]; then
	echo "[INFO][$time] Attempting to update $sysname with IP: $ip, at $time" >> "$logs" # Stating the same things to logs, if logs are enabled
fi

# Sudo/Not sudo commands
	# Variables to be used later on in the SSH Shell
if [ "$sudo" = "y" ]; then
	rm_ip='sudo rm "$ip_file"'       # Remove pre-exsisting log file as sudo
	touch_ip='sudo touch "$ip_file"' # Create log file as sudo
else
	rm_ip='rm "$ip_file"'       	 # Remove pre-exsisting log file not as sudo
    touch_ip='touch "$ip_file"'		 # Create log file not as sudo
fi

# Entering SSH Shell
	# SSH Shell are the commands that will be executed when connected to the server!

ssh -i $ssh_path -P $port $user@$server_ip || retry_ssh # If connection is successfull it will continue on, if not, it will go to the "retry_ssh" function

alias bye="exit"
# Aliased bye to exit to prevent any conflicts with the actual script ending not the ssh

$touch_rm
# Command referenced in "Sudo/Not sudo commands", variables are used to signify if the user has sudo privleges or not

$touch_ip
# Command referenced in "Sudo/Not sudo commands", variables are used to signify if the user has sudo privleges or not

echo "Current IP as of $time: $ip" >> "$ip_file"
# Echo the current IP and time into the log file

bye
# "Bye" used to prevent the script from ending when using "exit"


# Returning to Bash Shell
	# The Bash Shell is the shell while on the local machine

echo " "
echo "$sysname has been updated as of $time" # Stating that the remote has been updated
echo " "

if [ "$log" = "y" ]; then # Logging to logs if enabled
	echo "[INFO][$time] $sysname has been updated at $time with the IP $ip" >> "$logs"
	echo "[INFO][$time] $sysname will be updated again in $repeat_after seconds!" >> "$logs"
fi

if [ "$query_update" = "y" ]; then # Checking if a script/config update is available
	curl -o "$dir/IP-update.txt" "https://assets.mrmagicpie.xyz/update_ip/IP-update.txt" # Downloading TXT file containing the update status
	update_check="cat $dir/IP-update.txt"
	if [ "$update_check" = "An update is available" ]; then # Checking if the TXT file says theres an update
		echo " "
		echo "There is an update available! Review the update on https://github.com/Mrmagicpie"
		echo " "
		echo "Please respond with 'y' for yes, and 'n' for no, this will timeout in 25 seconds!"
		echo " "
		read -t 25 -p "Would you like to update now? (y/n) " update_maybe # Asking the user if they'd like to update. 
																		  # This will timeout to prevent the script from stopping when no user is present!

		if [ "$update_maybe" = "y" ] || [ "$update_maybe" = "yes" ]; then # Processing user input
			echo " "
			echo "We will update this script shortly!"
			echo " "
			sleep 3
			if ! [ -f "$dir/$0.old_update" ]; then # Moving current script, *Yes I know this isn't recommended but it'll be fiiiineeee :tm:*
				mv "$dir/$0" "$dir/$0.old_update"
			else # Asking  for filename if the other one exsists
				echo " "
				echo "The default old_update file is in use. Please specify a new old_update script name!"
				echo " "
				read -p "Example: update_ip.sh.old_update_two " new_update_file
				sleep 1
				echo " "
				echo "This script will be moved to '$dir/$new_update_file'! "
				echo " "
				mv "$dir/$0" "$dir/$new_update_file"
			fi

			curl -o "$dir/$0" "https://assets.mrmagicpie.xyz/update_ip/update_ip.sh" # Downloading the new file, and saving as the old name

			echo " "
			echo "This will timeout in 25 seconds, and this script will continue!"
			echo " "
			read -t 25 -p "Would you like to exit this script to start the updated one? (y/n) " update_leave # Asking if the user wants to leave this script
																											 # This will timeout incase the user leaves

			if [ "$update_leave" = "y" ] || [ "$update_leave" = "yes" ]; then # Exiting if the user says yes
				echo " "
				echo -e "Exiting this script! Use \033[0;31mbash $dir/$0\033[0m to restart!"
				echo " "
				sleep 3
				exit
			else # Not exiting the script
				echo " "
				echo "We will not exit this script! Continuing..."
				echo " "
				sleep 1
			fi
		fi
	fi
fi

sleep "$repeat_after" # Sleep the repeat after time. Specified in config, default to 1 hour(in seconds)
start

}

echo """
Hey! Welcome to the Update_IP.sh script written by Mrmagicpie!

The purpose of this script is to update your IP(via 'curl ifconfig.me') on a remote server every hour(by default)! There's a config for this script. Almost every part of it is configurable. Please checkout:
$dir/config.sh
""" # Main welcome echo

sleep 1

if [ "$default_log" = "y" ]; then # Checking if logs are enabled by default
	log="y"
elif [ "$default_log" = " " ] || [ "$default_log" = "n" ]; then # Checking if logs are disabled by default
	log="n"
else # Asking the user if they want logs(if not defined in config)
	echo -e "Logs are not enabled by default. By default the script will prompt you everytime, you can change this in your config. To enable auto logs make \033[0;32mdefault_log='y'\033[0m, to disable auto logs make \033[0;32mdefault_log='y'\033[0m"
	echo " "
	read -p "Enable logs? (y/n) " log
fi

if [ "$log" = "y" ]; then
	if ! [ -f "$logs" ]; then # Create logs file if it doesn't exist
        touch "$logs"
	fi
fi

start # Call the start function(to start the script, and loop)
