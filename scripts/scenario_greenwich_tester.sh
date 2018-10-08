#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -o errexit
set -o errtrace
set -o pipefail

cat <<EOF
This Bash file will show you the scenario in which Eureka Server is in finchley version and the Client is greenwich.
We will use a finchley Eureka Tester app to use a load balanced RestTemplate to find the "client" application.

We will do it in the following way:

01) Run eureka-finchley-server (Eureka Server)
02) Wait for the app (eureka-finchley-server) to boot (port: 8761)
03) Run eureka-greenwich-client (App registers in Eureka)
04) Wait for the app (eureka-greenwich-client) to boot (port: 8778)
05) Wait for the app (eureka-greenwich-client) to register in Eureka Server
06) Run eureka-finchley-tester (Will call the client app from Eureka)
07) Wait for the app (eureka-finchley-tester) to boot (port: 7779)
08) Wait for the app (eureka-finchley-tester) to register in Eureka Server
09) Now we have a finchley Eureka Server, finchley app that will call a greenwich app
10) Call localhost:7779/check to make the tester send a request to the client that will find the server
11) Assert that the flow is working
12) Kill eureka-finchley-server
13) Run eureka-greenwich-server (Eureka Server)
14) Wait for the app (eureka-greenwich-server) to boot (port: 8761)
15) Wait for the app (eureka-greenwich-client) to register in Eureka Server
16) Wait for the app (eureka-finchley-tester) to register in Eureka Server
17) Now we have a greenwich Eureka Server, finchley app that will call a greenwich app
18) Call localhost:7779/check to make the tester send a request to the client that will find the server
19) Assert that the flow is working
20) Kill eureka-greenwich-server
21) Kill eureka-greenwich-tester
22) Kill eureka-finchley-client

EOF

serverPort="8761"
java_jar eureka-finchley-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"

clientPort="8778"
java_jar eureka-greenwich-client "-Dserver.port=${clientPort}"
wait_for_new_boot_app_to_boot_on_port "${clientPort}"
check_app_presence_in_discovery CLIENT

testerPort="7779"
java_jar eureka-finchley-tester "-Dserver.port=${testerPort}"
wait_for_new_boot_app_to_boot_on_port "${testerPort}"
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\nfinchley app successfully communicated with a greenwich app via a finchley Eureka"
kill_app eureka-finchley-server

echo "Sleeping for 30 seconds"
sleep 30

java_jar eureka-greenwich-server "-Dserver.port=${serverPort}"
wait_for_new_boot_app_to_boot_on_port "${serverPort}"
check_app_presence_in_discovery CLIENT
check_app_presence_in_discovery TESTER

send_test_request "${testerPort}"
echo -e "\n\nfinchley app successfully communicated with a greenwich app via a greenwich Eureka"

kill_app eureka-greenwich-server
kill_app eureka-finchley-tester
kill_app eureka-greenwich-client
