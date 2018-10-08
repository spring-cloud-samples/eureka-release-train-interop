#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o pipefail

echo "Killing all apps"
pkill -f eureka-dalston || echo "Failed to kill any dalston apps"
pkill -f eureka-edgware || echo "Failed to kill any edgware apps"
pkill -f eureka-finchley || echo "Failed to kill any finchley apps"
pkill -f eureka-greenwich || echo "Failed to kill any greenwich apps"
