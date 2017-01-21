#!/bin/sh

# Move the data/plugin directory to the given location, if any
if [ -n "$MOUNT_AT" ]
then
    mkdir -p "$MOUNT_AT/"
    cp /data/* "$MOUNT_AT/"
fi

# Re-scan every 30 seconds
while true
do
    ruby scanner.rb
    cp -u /data/* "$MOUNT_AT/"
    sleep 30
done
