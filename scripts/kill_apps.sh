#!/usr/bin/env bash

echo "Killing all apps"
pkill -f eureka || echo "Failed to kill any apps"
