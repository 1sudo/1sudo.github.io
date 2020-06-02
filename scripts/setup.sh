#!/bin/bash

echo -e "\e[32m"
echo    "____________________________________________________________________"
echo    "|  _____ _____ ____  _____    _____ _____ _____ _____ _____ _____  |"
echo    "| |   __|  |  |    \|     |  |   __|     | __  |     |  _  |_   _| |"
echo    "| |__   |  |  |  |  |  |  |  |__   |   --|    -|-   -|   __| | |   |"
echo    "| |_____|_____|____/|_____|  |_____|_____|__|__|_____|__|    |_|   |"
echo    "===================================================================|"
echo    "|                 v1.0 - for swgemu core3 on wsl2                  |"
echo -e "====================================================================\n"
echo -e "\e[0m"

scripts="$HOME/github/1sudo.github.io/scripts"
script_url="https://raw.githubusercontent.com/1sudo/1sudo.github.io/master/scripts/setup_core3.sh"
ip=$(hostname -I)

# $scripts/setup_flag.sh

if [ ! -d ~/.scripts ]; then
    echo "Setting up SudoScript ..."
    mkdir ~/.scripts
    curl $script_url -o ~/.scripts/setup.sh 2>/dev/null
    chmod +x ~/.scripts/setup.sh
    echo "alias setup='~/.scripts/setup.sh'" >> ~/.bashrc
    exec bash
    echo "Done ..."
fi

PS3="> "

echo "What would you like to do?"
select opt in "Setup System" "Get And Configure Core3" "Compile Core3" "Copy Tre Files" Exit; do

  case $opt in
    "Setup System")
      $scripts/setup/setup_system.sh
      break
      ;;
    "Get And Configure Core3")
      $scripts/setup/setup_core3.sh
      break
      ;;
    "Compile Core3")
      $scripts/manage/compile_core3.sh
      break
      ;;
    "Copy Tre Files")
      $scripts/manage/copy_tre.sh
      break
      ;;
    Exit)
      break
      ;;
    *) 
      echo "Invalid option \"$REPLY\", please try again."
      ;;
  esac
done


# $scripts/setup_core3.sh