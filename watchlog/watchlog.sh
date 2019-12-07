#!/bin/bash

if [[ ! "$logfile" ]]; then
    echo "Please provide filename" >&2
    exit 1
fi

if [[ ! "$keyword" ]]; then
    echo "Please provide key word" >&2
fi

echo "Searching ${keyword} in ${logfile}"

grep "$keyword" "$logfile"
