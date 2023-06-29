#!/usr/bin/env bash

set -eu

# shellcheck disable=SC2046
cd "$(dirname "${BASH_SOURCE:-$0}")";
CURRENT_DIRECTORY=$(pwd)

if [[ ! -e ./tf-env.sh ]]; then
    echo "tf-env.sh is not found."
    exit 1
fi

echo "load tf-env.sh."
source ./tf-env.sh
cd "$CURRENT_DIRECTORY"

echo "perform terraform."
cd ../src/environments/dev || exit
terraform "$@"
