#!/usr/bin/env bash

set -o errexit

echo "Killing all apps"
#pkill -f eureka-dalston || echo "Failed to kill any dalston apps"
#pkill -f eureka-edgware || echo "Failed to kill any edgware apps"
#pkill -f eureka-finchley || echo "Failed to kill any finchley apps"
#pkill -f eureka-greenwich || echo "Failed to kill any greenwich apps"
#pkill -f eureka-hoxton || echo "Failed to kill any hoxton apps"
pkill -f eureka-ilford || echo "Failed to kill any ilford apps"
pkill -f eureka-kilburn || echo "Failed to kill any kilburn apps"
