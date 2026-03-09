#!/usr/bin/env bash

# https://ipapi.co/
# curl https://ipapi.co/ip
# curl https://ipapi.co/json
# curl https://ipapi.co/176.9.119.22/latlong/

current_ip=$(curl -s http://ifconfig.io/ip)

echo "$current_ip"

exit 0
