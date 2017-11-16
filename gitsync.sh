#!/bin/bash

# Configuration Variables
valid=("checkout" "pull" "prune" "delete")
default=("dir1" "dir2" "dir3")

# Git Commands
checkout() {
    echo git -C $1 checkout $branch --
    git -C $1 checkout $branch --
}

pull() {
    echo git -C $1 pull origin --
    git -C $1 pull origin --
}

prune() {
    echo git -C $1 remote prune origin --
    git -C $1 remote prune origin --
}

delete() {
    current=$(git -C $1 symbolic-ref --short -q HEAD)
    branches=$(git -C $1 branch | tr '*' ' ')

    for br in $branches; do
        if [ $br != $current ] && [ "$br" != "master" ]; then
            if [ "$option" = "-f" ]; then
                echo git -C $1 branch -D $br
                git -C $1 branch -D $br
            else
                printf "Delete $1->$br? (y/n/exit): "
                read -r confirm
                if [ "$confirm" = "y" ]; then
                    echo git -C $1 branch -D $br
                    git -C $1 branch -D $br
                elif [ "$confirm" = "exit" ]; then
                    exit 0
                fi
            fi
        fi
    done
    
}
# End Git Commands

# Begin Script
branch="master"
command=$1

# Print Usage
if [ -z $1 ]; then
    echo Usage: gitsync [command] [directory] [option]
    echo Website: https://github.com/Siphon098/git-sync-batch
    exit 1
fi

# Read Arguments
index=0
skip=false
for arg in $@; do
    index=$((index+1))
    if [ $skip = true ]; then
        skip=false
    elif [ $index = 1 ]; then
        command=$arg
    else
        if [ ${arg:0:2} = "-b" ]; then
            option=$arg
            next=$((index+1))
            branch=${!next}
            skip=true
        elif [ ${arg:0:1} = "-" ]; then
            option=$arg
        elif [ $index = 2 ]; then
            dirs=$arg
        fi
    fi
done

# Set Default Directores
if [ -z $dirs ]; then
    dirs=${default[*]}
fi

# Run Commands
if [[ "${valid[@]}" =~ "${command}" ]]; then
    for i in ${default[@]}; do
        $command $i
    done
elif [ $command = all ]; then
    for i in ${default[@]}; do
        checkout $i
        pull $i
        prune $i
    done
fi

exit 0