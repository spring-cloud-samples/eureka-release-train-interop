#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -o errexit
set -o errtrace
set -o pipefail

cat <<EOF
This Bash file will show you the scenario in which Eureka Server is in edgware version and the Client is finchley.
We will use a edgware Eureka Tester app to use a load balanced RestTemplate to find the "client" application.

We will do it in the following way:

01) Run eureka-edgware-server (Eureka Server)
02) Wait for the app (eureka-edgware-server) to boot (port: 8761)
03) Run eureka-finchley-client (App registers in Eureka)
04) Wait for the app (eureka-finchley-client) to boot (port: 8778)
05) Wait for the app (eureka-finchley-client) to register in Eureka Server
06) Run eureka-edgware-tester (Will call the client app from Eureka)
07) Wait for the app (eureka-edgware-tester) to boot (port: 7779)
08) Wait for the app (eureka-edgware-tester) to register in Eureka Server
09) Now we have a edgware Eureka Server, edgware app that will call a finchley app
10) Call localhost:7779/check to make the tester send a request to the client that will find the server
11) Assert that the flow is working
12) Kill eureka-edgware-server
13) Run eureka-finchley-server (Eureka Server)
14) Wait for the app (eureka-finchley-server) to boot (port: 8761)
15) Wait for the app (eureka-finchley-client) to register in Eureka Server
16) Wait for the app (eureka-edgware-tester) to register in Eureka Server
17) Now we have a finchley Eureka Server, edgware app that will call a finchley app
18) Call localhost:7779/check to make the tester send a request to the client that will find the server
19) Assert that the flow is working
20) Kill eureka-finchley-server
21) Kill eureka-finchley-tester
22) Kill eureka-edgware-client

EOF

java_jar eureka-edgware-server
wait_for_app_to_boot_on_port 8761

java_jar eureka-finchley-client
wait_for_new_boot_app_to_boot_on_port 8778
check_app_presence_in_discovery CLIENT

java_jar eureka-edgware-tester
wait_for_app_to_boot_on_port 7779
check_app_presence_in_discovery TESTER

send_test_request 7779
echo -e "\n\nedgware app successfully communicated with a finchley app via a edgware Eureka"
kill_app eureka-edgware-server

echo "Sleeping for 30 seconds"
sleep 30

java_jar eureka-finchley-server
wait_for_new_boot_app_to_boot_on_port 8761
check_app_presence_in_discovery CLIENT
check_app_presence_in_discovery TESTER

send_test_request 7779
echo -e "\n\nedgware app successfully communicated with a finchley app via a finchley Eureka"

kill_app eureka-finchley-server
kill_app eureka-edgware-tester
kill_app eureka-finchley-client
