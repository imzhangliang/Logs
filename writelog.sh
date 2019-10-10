#!/bin/bash

LOGTYPE=$1

LOG_ROOT_DIR=${HOME}/Documents/Logs
CUR_DATE=$(date +%Y%m%d)
DEFAULT_FILENAME="${CUR_DATE}.md"

LOG_TYPES=("work" "video" "book")


usage() {
    echo "Usage: $0 -t log_type [ -c sub_category ] [filename]"
    echo "Description: log_type is one of the categories: ${LOG_TYPES[@]}"
}

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


FILENAME=${DEFAULT_FILENAME}

# parse arguments
while getopts "t:c:" options; do
    case "${options}" in 
        c) 
            SUB_CATE=${OPTARG}
            ;;
        t)
            LOG_TYPE=${OPTARG}
            ;;
    esac
done


# log type must exist
if [ "$LOG_TYPE" == "" ]; then
    usage
    exit 1
fi

# check if log type is valid
if [ $(contains "${LOG_TYPES[@]}" "$LOG_TYPE") == "n" ]; then
    usage
    echo "error: invalid log type!"
    exit 2
fi

# create directories if not exist
WORK_DIR="${LOG_ROOT_DIR}/${LOG_TYPE}"
mkdir -p ${WORK_DIR}


cd ${WORK_DIR}

# write default information in front of the content
[ -e "$FILENAME" ] || cat > ${FILENAME} << EOF
---
date: ${CUR_DATE}
---
EOF

# use vscode to edit the log file
code ${FILENAME}