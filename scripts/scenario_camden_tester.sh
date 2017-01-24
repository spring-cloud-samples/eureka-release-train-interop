#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -e

echo -e "Ensure that all the apps are built!\n"
build_all_apps


cat <<EOF
This Bash file will show you the scenario in which Eureka Server is in Brixton version and the Client is Camden.
We will use a Brixton Eureka Tester app to use a load balanced RestTemplate to find the "client" application.

We will do it in the following way:

01) Run eureka-brixton-server (Eureka Server)
02) Wait for the app (eureka-brixton-server) to boot (port: 8761)
03) Run eureka-brixton-client (App registers in Eureka)
04) Wait for the app (eureka-brixton-client) to boot (port: 7778)
05) Wait for the app (eureka-brixton-client) to register in Eureka Server
06) Run eureka-camden-tester (Will call the client app from Eureka)
07) Wait for the app (eureka-camden-tester) to boot (port: 8779)
08) Wait for the app (eureka-camden-tester) to register in Eureka Server
09) Now we have a Brixton Eureka Server, Camden app that will call a Brixton app
10) Call localhost:8779/check to make the tester send a request to the client that will find the server
11) Assert that the flow is working
12) Kill eureka-brixton-server
13) Run eureka-camden-server (Eureka Server)
14) Wait for the app (eureka-camden-server) to boot (port: 8761)
15) Wait for the app (eureka-brixton-client) to register in Eureka Server
16) Wait for the app (eureka-camden-tester) to register in Eureka Server
17) Now we have a Camden Eureka Server, Camden app that will call a Brixton app
18) Call localhost:8779/check to make the tester send a request to the client that will find the server
19) Assert that the flow is working
20) Kill eureka-camden-server
21) Kill eureka-camden-tester
22) Kill eureka-brixton-client

EOF

java_jar eureka-brixton-server
wait_for_app_to_boot_on_port 8761

java_jar eureka-brixton-client
wait_for_app_to_boot_on_port 7778
check_app_presence_in_discovery CLIENT

java_jar eureka-camden-tester
wait_for_app_to_boot_on_port 8779
check_app_presence_in_discovery TESTER

send_test_request 8779
echo -e "\n\nCamden app successfully communicated with a Brixton app via a Brixton Eureka"
kill_app eureka-brixton-server

java_jar eureka-camden-server
wait_for_app_to_boot_on_port 8761
check_app_presence_in_discovery CLIENT
check_app_presence_in_discovery TESTER

send_test_request 8779
echo -e "\n\nCamden app successfully communicated with a Brixton app via a Camden Eureka"

kill_app eureka-camden-server
kill_app eureka-camden-tester
kill_app eureka-brixton-client
