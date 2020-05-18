#!/bin/bash

ip = $(hostname -I)

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

function update_system () {
    read -p "Before setting up Core3, we need to perform some system updates, is this okay? `echo $'\n '`(Default: 'n') `echo $'\n> '`" update_system
    update_system=${update_system:-n}

    if [[ $update_system == "n" || $update_system == "no" ]]; then
        echo "We will not update your system, exiting ..."
        exit 1
    elif [[ $update_system == "y" || $update_system == "yes" ]]; then
        touch ~/.setup_flag
        echo "Updating package database ... Please wait ..."
        sudo apt-get update -qq
        echo "Upgrading system ... Please wait ..."
        sudo apt-get upgrade -y -qq
        echo -e "Installing required packages ... Please wait ...\n"
        sudo apt-get install build-essential libmysqlclient-dev liblua5.3-dev libdb5.3-dev libssl-dev cmake git default-jre mysql-server curl -y -qq
    else
        echo "Invalid option specified, exiting ..."
        exit 1
    fi
}

if [ -f ~/.setup_flag ]; then
    echo "It appears you've already run the setup before."
    read -p "  Do you need to run it again? `echo $'\n> '`" setup_again

    if [[ $setup_again == "y" || $setup_again == "yes" ]]; then
        rm -f ~/.setup_flag
        update_system
    else
        echo "We will not run the setup again, exiting ..."
        exit 1
    fi
else
    update_system
fi

read -p "Enter your SWGEmu Core3 git repo URL `echo $'\n '` \
(Default: 'https://github.com/swgemu/Core3.git') `echo $'\n> '`" core3_repo
core3_repo=${core3_repo:-https://github.com/swgemu/Core3.git}
echo ""

read -p "Enter the branch in your Core3 repo you wish to pull from: `echo $'\n '` \
(Default: 'unstable'): `echo $'\n> '`" core3_branch 
core3_branch=${core3_branch:-unstable}
echo ""

if [ ! -d ~/workspace ]; then
    mkdir ~/workspace
fi

if [ -d ~/workspace/Core3 ]; then
    read -p "Core3 directory already exists, delete it and continue? `echo $'\n '` \
    (Default: 'n'): `echo $'\n> '`" core3_exists
    core3_exists=${core3_exists:-n}

    if [[ $core3_exists == "y" || $core3_exists == "yes" ]]; then
        rm -rf ~/workspace/Core3

        # If we fail to delete the Core3 directory, delete as su
        if [ $? -gt 0 ]; then
            sudo rm -rf ~/workspace/Core3
        fi
    else
        "We will not delete the existing Core 3 directory, exiting ..."
        exit 1
    fi
fi

echo "Cloning Core3 ... Please wait ..."
git clone --quiet -b $core3_branch $core3_repo ~/workspace/Core3

# Kill script if cloning fails
if [ $? -gt 0 ]; then
    exit 1
fi

# Check for missing parent directory
if [ -d ~/workspace/Core3/src ]; then
    mkdir -p ~/workspace/setup_temp/MMOCoreORB
    shopt -s dotglob nullglob
    mv ~/workspace/Core3/* ~/workspace/setup_temp/MMOCoreORB
    mv ~/workspace/setup_temp/MMOCoreORB ~/workspace/Core3/
    shopt -u dotglob nullglob
    rm -rf ~/workspace/setup_temp
fi

if [ ! -f ~/workspace/Core3/.gitmodules ]; then
    read -p "Enter your Public Engine git repo URL: `echo $'\n '` \
    (No default, we've detected an old version of Core3!) `echo $'\n> '`" engine_repo

    read -p "Enter the branch from the Public Engine repo you wish to pull from: `echo $'\n '` \
    (No default, we've detected an old version of Core3!) `echo $'\n> '`" engine_branch

    if [ $engine_repo == "" ]; then
        echo "No valid submodule URL provided, exiting ..."
        exit 1
    else
        if [ -d ~/workspace/PublicEngine ]; then
            read -p "Public Engine directory already exists, delete it and continue? `echo $'\n '` \
            (Default: 'n'): `echo $'\n> '`" engine_exists
            engine_exists=${engine_exists:-n}

            if [[ $engine_exists == "y" || $engine_exists == "yes" ]]; then
                rm -rf ~/workspace/PublicEngine

                # If we fail to delete the PublicEngine directory, delete as su
                if [ $? -gt 0 ]; then
                    sudo rm -rf ~/workspace/PublicEngine
                fi
            else
                "We will not delete the existing Public Engine directory, exiting ..."
                exit 1
            fi
        fi

        echo "Cloning Public Engine ... Please wait ..."
        git clone --quiet -b $engine_branch $engine_repo ~/workspace/PublicEngine

        # If clone fails, exit
        if [ $? -gt 0 ]; then
            exit 1
        fi

        # Check for missing parent directory
        if [ -d ~/workspace/PublicEngine/bin ]; then
            mkdir -p ~/workspace/setup_temp/MMOEngine
            shopt -s dotglob nullglob
            mv ~/workspace/PublicEngine/* ~/workspace/setup_temp/MMOEngine
            mv ~/workspace/setup_temp/MMOEngine ~/workspace/PublicEngine/
            shopt -u dotglob nullglob
            rm -rf ~/workspace/setup_temp
        fi

        echo "Compiling Engine ..."
        cd $HOME/workspace/PublicEngine/MMOEngine && make
        echo "Symlinking Engine ..."
        ln -s $HOME/workspace/PublicEngine/MMOEngine $HOME/workspace/Core3/MMOEngine
    fi
fi

