#!/bin/sh

# Path to the log file
LOG_FILE="/var/log/tailscaleTools/tailCheck.log"

# Log the received IP address for debugging
echo "Received IP address: $1" >> $LOG_FILE

if [ -z "$1" ]; then
    echo "$(date) No IP address provided." >> $LOG_FILE
    exit 1
fi

# IP Address to ping
TARGET_IP="$1"

# Record the start time in the log
echo "$(date) Starting ping operation at for IP $TARGET_IP" >> $LOG_FILE

# Ping the target IP 2 times and log the output
ping -c 2 $TARGET_IP

# Check if the ping command succeeded
if [ $? -ne 0 ]; then
    echo "$(date) Ping to $TARGET_IP failed, restarting Tailscale service..." >> $LOG_FILE
    # Restart the Tailscale service and log the action
    sudo service tailscaled restart >> $LOG_FILE 2>&1
    echo "$(date) Tailscale service restarted" >> $LOG_FILE
else
    echo "$(date) Ping to $TARGET_IP successful." >> $LOG_FILE
fi
