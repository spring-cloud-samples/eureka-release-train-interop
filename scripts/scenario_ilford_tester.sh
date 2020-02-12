#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -o errexit
set -o errtrace
set -o pipefail

cat <<EOF
This Bash file will show you the scenario in which Eureka Server is in hoxton version and the Client is ilford.
We will use a hoxton Eureka Tester app to use a load balanced RestTemplate to find the "client" application.

We will do it in the following way:

01) Run eureka-hoxton-server (Eureka Server)
02) Wait for the app (eureka-hoxton-server) to boot (port: 8761)
03) Run eureka-ilford-client (App registers in Eureka)
04) Wait for the app (eureka-ilford-client) to boot (port: 8778)
05) Wait for the app (eureka-ilford-client) to register in Eureka Server
06) Run eureka-hoxton-tester (Will call the client app from Eureka)
07) Wait for the app (eureka-hoxton-tester) to boot (port: 7779)
08) Wait for the app (eureka-hoxton-tester) to register in Eureka Server
09) Now we have a hoxton Eureka Server, hoxton app that will call a ilford app
10) Call localhost:7779/check to make the tester send a request to the client that will find the server
11) Assert that the flow is working
12) Kill eureka-hoxton-server
13) Run eureka-ilford-server (Eureka Server)
14) Wait for the app (eureka-ilford-server) to boot (port: 8761)
15) Wait for the app (eureka-ilford-client) to register in Eureka Server
16) Wait for the app (eureka-hoxton-tester) to register in Eureka Server
17) Now we have a ilford Eureka Server, hoxton app that will call a ilford app
18) Call localhost:7779/check to make the tester send a request to the client that will find the server
19) Assert that the flow is working
20) Kill eureka-ilford-server
21) Kill eureka-ilford-tester
22) Kill eureka-hoxton-client

EOF

serverPort="8761"
java_jar eureka-hoxton-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"

clientPort="8778"
java_jar eureka-ilford-client "-Dserver.port=${clientPort}"
wait_for_new_boot_app_to_boot_on_port "${clientPort}"
check_app_presence_in_discovery CLIENT

testerPort="7779"
java_jar eureka-hoxton-tester "-Dserver.port=${testerPort}"
wait_for_new_boot_app_to_boot_on_port "${testerPort}"
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\nhoxton app successfully communicated with a ilford app via a hoxton Eureka"
kill_app eureka-hoxton-server

echo "Sleeping for 30 seconds"
sleep 30

java_jar eureka-ilford-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"
check_app_presence_in_discovery CLIENT
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\nhoxton app successfully communicated with a ilford app via a ilford Eureka"

kill_app eureka-ilford-server
kill_app eureka-hoxton-tester
kill_app eureka-ilford-client
