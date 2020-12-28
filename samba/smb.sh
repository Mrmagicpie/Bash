#!/bin/bash

#
# Mrmagicpie Samba Installer. This Bash script
# will install, and setup Samba for you!
#
# Security: Please use external methods to
# secure your Samba such as UFW/IPTables!
#

# # # # # # # # # # # # # # # # # # # # # # # # # # #

setup_complete_menu()
{
  setup=$(whiptail --title "Post Setup Menu" --fb --menu "Choose an option" 15 60 4 \
        "1" "Add Samba Share" \
        "2" "Execute Bulk Check" \
        "3" "Exit to Top Menu" 3>&1 1>&2 2>&3)
  case $setup in
    1)
      setupBulkCheckCsv
      whiptail --title "Setup Complete" --msgbox "" 6 40
      csvMenu
      ;;
    2)
      echo -e "\e[31mExecuting Bulk Check\e[0m"
      runBulkCheckCsv
      whiptail --title "Bulk Check Complete" --msgbox "" 6 40
      csvMenu
      ;;
    3)
      topMenu
      ;;
  esac
}

setup_basic()
{
  .
}

main_menu()
{
  if [ -f "/etc/samba/.mrmagicpie_setup.txt" ]; then
    setup_complete_menu
  fi
  main=$(whiptail --title "Main Menu" --fb --menu "Choose an option" 15 60 4 \
        "1" "Setup Basic Samba" \
        "2" "Exit Script" 3>&1 1>&2 2>&3)
  case $main in
    1)
      setup_basic
      whiptail --title "Setup Complete" --msgbox "The basic setup has completed!" 6 40
      setup_complete_menu
      ;;
    2)
      echo
      echo "Exiting this script! Run \"bash $0\" to restart the script."
      echo
      sleep 3
      exit
      ;;
    *)
      echo
      echo "Invalid option!"
      echo
      sleep 2
      main_menu
  esac
}

main_menu