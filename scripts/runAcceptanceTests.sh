#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -o errexit
set -o errtrace
set -o pipefail

echo -e "Ensure that all the apps are built!\n"
build_all_apps

trap "{ ${ROOT_FOLDER}/scripts/kill_apps.sh; }" EXIT

#${ROOT_FOLDER}/scripts/scenario_brixton_tester.sh
#${ROOT_FOLDER}/scripts/scenario_camden_tester.sh
#${ROOT_FOLDER}/scripts/scenario_dalston_tester.sh
#${ROOT_FOLDER}/scripts/scenario_edgware_tester.sh
# ${ROOT_FOLDER}/scripts/kill_apps.sh
# ${ROOT_FOLDER}/scripts/scenario_finchley_tester.sh
# ${ROOT_FOLDER}/scripts/kill_apps.sh
# ${ROOT_FOLDER}/scripts/scenario_greenwich_tester.sh
# ${ROOT_FOLDER}/scripts/kill_apps.sh
# ${ROOT_FOLDER}/scripts/scenario_hoxton_tester.sh
# ${ROOT_FOLDER}/scripts/kill_apps.sh
#${ROOT_FOLDER}/scripts/scenario_ilford_tester.sh
#${ROOT_FOLDER}/scripts/kill_apps.sh
${ROOT_FOLDER}/scripts/scenario_jubilee_tester.sh
${ROOT_FOLDER}/scripts/kill_apps.sh
${ROOT_FOLDER}/scripts/scenario_kilburn_tester.sh
${ROOT_FOLDER}/scripts/kill_apps.sh
