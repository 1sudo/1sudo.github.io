#!/bin/bash

scripts="$HOME/github/1sudo.github.io/scripts"

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

            # If delete fails as su, try removing immutable bit
            if [ $? -gt 0 ]; then
                sudo chattr -i ~/workspace/Core3
                sudo rm -rf ~/workspace/Core3
            else
                echo "Unable to delete Core3 directory, exiting ..."
                exit 1
            fi
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

                    # If delete fails as su, try removing immutable bit
                    if [ $? -gt 0 ]; then
                        sudo chattr -i ~/workspace/PublicEngine
                        sudo rm -rf ~/workspace/PublicEngine
                    else
                        echo "Unable to delete PublicEngine directory, exiting ..."
                        exit 1
                    fi
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

$scripts/setup.sh