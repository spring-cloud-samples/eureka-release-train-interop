#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -o errexit
set -o errtrace
set -o pipefail

cat <<EOF
This Bash file will show you the scenario in which Eureka Server is in ilford version and the Client is jubilee.
We will use a ilford Eureka Tester app to use a load balanced RestTemplate to find the "client" application.

We will do it in the following way:

01) Run eureka-ilford-server (Eureka Server)
02) Wait for the app (eureka-ilford-server) to boot (port: 8761)
03) Run eureka-jubilee-client (App registers in Eureka)
04) Wait for the app (eureka-jubilee-client) to boot (port: 8778)
05) Wait for the app (eureka-jubilee-client) to register in Eureka Server
06) Run eureka-ilford-tester (Will call the client app from Eureka)
07) Wait for the app (eureka-ilford-tester) to boot (port: 7779)
08) Wait for the app (eureka-ilford-tester) to register in Eureka Server
09) Now we have a ilford Eureka Server, ilford app that will call a jubilee app
10) Call localhost:7779/check to make the tester send a request to the client that will find the server
11) Assert that the flow is working
12) Kill eureka-ilford-server
13) Run eureka-jubilee-server (Eureka Server)
14) Wait for the app (eureka-jubilee-server) to boot (port: 8761)
15) Wait for the app (eureka-jubilee-client) to register in Eureka Server
16) Wait for the app (eureka-ilford-tester) to register in Eureka Server
17) Now we have a jubilee Eureka Server, ilford app that will call a jubilee app
18) Call localhost:7779/check to make the tester send a request to the client that will find the server
19) Assert that the flow is working
20) Kill eureka-jubilee-server
21) Kill eureka-jubilee-tester
22) Kill eureka-ilford-client

EOF

serverPort="8761"
java_jar eureka-ilford-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"

clientPort="8778"
java_jar eureka-jubilee-client "-Dserver.port=${clientPort}"
wait_for_new_boot_app_to_boot_on_port "${clientPort}"
check_app_presence_in_discovery CLIENT

testerPort="7779"
java_jar eureka-ilford-tester "-Dserver.port=${testerPort}"
wait_for_new_boot_app_to_boot_on_port "${testerPort}"
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\nilford app successfully communicated with a jubilee app via a ilford Eureka"
kill_app eureka-ilford-server

echo "Sleeping for 30 seconds"
sleep 30

java_jar eureka-jubilee-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"
check_app_presence_in_discovery CLIENT
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\nilford app successfully communicated with a jubilee app via a jubilee Eureka"

kill_app eureka-jubilee-server
kill_app eureka-ilford-tester
kill_app eureka-jubilee-client
