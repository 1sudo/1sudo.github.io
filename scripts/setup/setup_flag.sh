#!/bin/bash

scripts="$HOME/github/1sudo.github.io/scripts"

if [ -f ~/.setup_flag ]; then
    echo "It appears you've already run the setup before."
    read -p "  Do you need to run it again? `echo $'\n> '`" setup_again

    if [[ $setup_again == "y" || $setup_again == "yes" ]]; then
        rm -f ~/.setup_flag
        $scripts/setup_system.sh
    else
        echo "We will not run the setup again, exiting ..."
        exit 1
    fi
else
    $scripts/setup_system.sh
fi