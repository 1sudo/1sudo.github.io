#!/bin/bash

read -p "Enter the path to your tre files: `echo -e '\n '` \
As an example, if your tre files are located in C:\SWGEmu, \
You would enter 'c/swgemu' `echo -e '\n '` \
If your directory has spaces in its name, remove the spaces. `echo -e '\n '` \
If it's in a directory that has a space in it's name, move it to a directory that doesn't. `echo $'\n> '`" tre_dir

path=$(wslpath -u $tre_dir)
