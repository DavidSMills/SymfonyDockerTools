#!/bin/bash

# This script remove all CSV, LOCK, XML and XLSX files from feeds

parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path/../feeds"

# Allowed delete format
allowedFormat=("csv" "lock" "xml" "xlsx")

# Check if a string is contained in an array
function contains() {
  local n=$#
  local value=${!n}
  for ((i=1;i < $#;i++)) {
    if [ "${!i}" == "${value}" ]; then
        echo "y"
        return 0
    fi
  }
  echo "n"
  return 1
}

# If there is an option
while getopts ":f" opt; do
  case $opt in
    f)
      if [ "$#" -eq 1 ]
      then
        echo -e "\nOption force activated, all csv, lock, xml and xlsx files deleted" >&2
        find . -name "*.csv" -print0 | xargs -0 rm -rf
        find . -name "*.lock" -print0 | xargs -0 rm -rf
        find . -name "*.xml" -print0 | xargs -0 rm -rf
        find . -name "*.xlsx" -print0 | xargs -0 rm -rf
      else
        for args in "$@"; do
          if [ $(contains "${allowedFormat[@]}" "$args") == "y" ]
          then
            echo -e "\nOption force activated, all $args files deleted" >&2
            find . -name "*.$args" -print0 | xargs -0 rm -rf
          else
            if [[ "$args" != "-f" ]]
            then
              echo -e "\nFormat $args is not allowed" >&2
            fi
          fi
        done
      fi
      exit 0
      ;;
    \?)
      echo -e "\nInvalid option: -$OPTARG" >&2
      exit 0
      ;;
  esac
done

echo

# Function to ask a question for remove or keep files
# $1 is the type of file
function askRemoveFile {

  count=$(find . -name "*.$1" | wc -l)
  if [ $count -eq 0 ]
  then
    echo -e "There are no $1 files to delete\n"
  else

    echo -e "Files:\n"
    find . -name "*.$1"
    echo

    read -p "Do you want to delete these $1 files? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        find . -name "*.$1" -print0 | xargs -0 rm -rf
        echo  -e "\n\nFiles removed\n"
    else
        echo  -e "\n\n$1 files kept\n"
    fi

  fi

}

askRemoveFile "csv"
askRemoveFile "lock"
askRemoveFile "xml"
askRemoveFile "xlsx"