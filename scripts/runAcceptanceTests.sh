#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -e

echo -e "Ensure that all the apps are built!\n"
build_all_apps

#${ROOT_FOLDER}/scripts/scenario_brixton_tester.sh
#${ROOT_FOLDER}/scripts/scenario_camden_tester.sh
#${ROOT_FOLDER}/scripts/scenario_dalston_tester.sh
#${ROOT_FOLDER}/scripts/scenario_edgware_tester.sh
${ROOT_FOLDER}/scripts/kill_apps.sh
${ROOT_FOLDER}/scripts/scenario_finchley_tester.sh
${ROOT_FOLDER}/scripts/kill_apps.sh
