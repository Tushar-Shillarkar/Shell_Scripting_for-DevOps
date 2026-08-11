#!/bin/bash

<< readme
this is a script for backup with 5 day rotation
usage:
./backup.sh <path to your source> <path to backup folder>
readme

function display_usage {
        echo ":Useage: ./backup.sh <path to your source> < path to backup folder>"
}

if [ $# -eq 0 ]; then
        display_usage
fi
source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
back_dir=$2

function create_backup {
        zip -r "${back_dir}/backup${timestamp}.zip" "${source_dir}" > /dev/null

        if [ $? -eq 0 ]; then
                echo "Backup generated successfully: /backup_${timestamp}.zip"
        else
                echo "Backup failed!" >&2
                exit 1
        fi
}
function perform_rotation {
        backups=($(ls -t "${back_dir}/backup"*.zip 2>/dev/null))

        if [ "${#backups[@]}" -gt 5 ]; then
                echo "Performing rotation for 5 days"

                backups_to_remove=("${backups[@]:5}")


                for backup in "${backups_to_remove[@]}";
                do
                        rm -f ${backup}
                done
        fi
}

create_backup
perform_rotation
