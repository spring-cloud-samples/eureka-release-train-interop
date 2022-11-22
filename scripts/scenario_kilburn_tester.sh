#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -o errexit
set -o errtrace
set -o pipefail

cat <<EOF
This Bash file will show you the scenario in which Eureka Server is in jubilee version and the Client is kilburn.
We will use a jubilee Eureka Tester app to use a load balanced RestTemplate to find the "client" application.

We will do it in the following way:

01) Run eureka-jubilee-server (Eureka Server)
02) Wait for the app (eureka-jubilee-server) to boot (port: 8761)
03) Run eureka-kilburn-client (App registers in Eureka)
04) Wait for the app (eureka-kilburn-client) to boot (port: 8778)
05) Wait for the app (eureka-kilburn-client) to register in Eureka Server
06) Run eureka-jubilee-tester (Will call the client app from Eureka)
07) Wait for the app (eureka-jubilee-tester) to boot (port: 7779)
08) Wait for the app (eureka-jubilee-tester) to register in Eureka Server
09) Now we have a jubilee Eureka Server, jubilee app that will call a kilburn app
10) Call localhost:7779/check to make the tester send a request to the client that will find the server
11) Assert that the flow is working
12) Kill eureka-jubilee-server
13) Run eureka-kilburn-server (Eureka Server)
14) Wait for the app (eureka-kilburn-server) to boot (port: 8761)
15) Wait for the app (eureka-kilburn-client) to register in Eureka Server
16) Wait for the app (eureka-jubilee-tester) to register in Eureka Server
17) Now we have a kilburn Eureka Server, jubilee app that will call a kilburn app
18) Call localhost:7779/check to make the tester send a request to the client that will find the server
19) Assert that the flow is working
20) Kill eureka-kilburn-server
21) Kill eureka-kilburn-tester
22) Kill eureka-jubilee-client

EOF

serverPort="8761"
java_jar eureka-jubilee-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"

clientPort="8778"
java_jar eureka-kilburn-client "-Dserver.port=${clientPort}"
wait_for_new_boot_app_to_boot_on_port "${clientPort}"
check_app_presence_in_discovery CLIENT

testerPort="7779"
java_jar eureka-jubilee-tester "-Dserver.port=${testerPort}"
wait_for_new_boot_app_to_boot_on_port "${testerPort}"
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\njubilee app successfully communicated with a kilburn app via a jubilee Eureka"
kill_app eureka-jubilee-server

echo "Sleeping for 30 seconds"
sleep 30

java_jar eureka-kilburn-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"
check_app_presence_in_discovery CLIENT
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\njubilee app successfully communicated with a kilburn app via a kilburn Eureka"

kill_app eureka-kilburn-server
kill_app eureka-jubilee-tester
kill_app eureka-kilburn-client
