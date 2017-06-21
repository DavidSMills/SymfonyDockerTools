#!/bin/bash

# This script create all files associated to a dist file 

parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path/.."


# Display all dist files
function displayDist {

  echo -e "\n-> Root files\n"
  find . -maxdepth 1 -name "*.dist" -type f
  echo -e "\n-> app/config files\n"
  find app/config -name "*.dist" -type f
  echo

}

# Function to ask a question for create files associated on dist files
function askCreateFile {

  countRoot=$(find . -maxdepth 1 -name "*.dist" -type f | wc -l)
  countfolder=$(find app/config -name "*.dist" -type f | wc -l)

  if [ $[countRoot+countfolder] -eq 0 ]
  then
    echo -e "There are no .dist files to create\n"
    exit 0
  else

    displayDist

    read -p "Do you want to create associated dist files? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        FILESROOT=`find . -maxdepth 1 -name "*.dist" -type f | xargs -r`
        for FILE in $FILESROOT; do
            cp -n $FILE ${FILE::-5}
        done
        FILESFOLDER=`find app/config -name "*.dist" -type f | xargs -r`
        for FILE in $FILESFOLDER; do
            cp -n $FILE ${FILE::-5}
        done
        echo  -e "\n\nFiles created"
    else
        echo  -e "\n\nNothing to do !"
    fi

  fi

}

# Main program
askCreateFile
