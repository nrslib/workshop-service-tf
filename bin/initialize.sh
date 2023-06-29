#!/bin/bash

WORKDIR=$(pwd)
cd "$(dirname "$0")"

echo -n "terraform 実行用 AWS Profile を指定してください:"
read -r aws_profile

./bin/shell-cst-service-tf-initialize-individual-environment/bin/run.sh --profile "$aws_profile"
