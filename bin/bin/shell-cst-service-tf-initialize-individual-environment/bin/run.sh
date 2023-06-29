#!/bin/bash

val2() {
  eval "$1"='"${2}"'
}

msg() {
  echo
  echo "-----"
  echo "$1"
  echo "-----"
}

usage() {
  cat <<EOS
usage: $(basename "$0") [--profile <aws_profile>] [--region <aws_region>]
EOS
}

init() {
  account_id=$(aws sts get-caller-identity --profile "$aws_profile" | jq --raw-output .Account)

  info
}

info() {
  cat <<EOS
==========
Information: Arguments
----------
aws_profile:  "$aws_profile"
prefix:       "$prefix"
project_name: "$project_name"
==========

==========
Information: Initialized variables
----------
account_id    "$account_id"
==========
EOS
}

require_not_empty() {
  eval "value=\$$1"
  if [ -z "$value" ]; then
    echo "$2"
    exit 1
  fi
  return 0
}

while getopts "h-:" opt_char; do
  case "$opt_char" in
    -)
      case "${OPTARG}" in
        help)
          usage
          exit 1
          ;;
        profile)
          val2 aws_profile "${!OPTIND}"
          OPTIND=$(( $OPTIND + 1 ))
          ;;
        *)
          echo "'--$OPTARG'" is not a option.
          exit 1
          ;;
      esac
      ;;
    h)
      usage
      exit 1
      ;;
    *)
      echo "-$opt_char" is not a option.
      exit 1
      ;;
  esac
done

if [ -z "$aws_profile" ]; then
  echo -n "terraform 実行用 AWS Profile を指定してください:"
  read -r aws_profile
fi
require_not_empty aws_profile "AWS Profile を指定する必要があります。"

echo -n "prefix を指定してください (ex. nrs-d1, nrs-v1, etc.):"
read -r prefix
require_not_empty prefix "Prefix を指定する必要があります。"

echo -n "プロジェクト名を指定してください（ex. workshop-service）:"
read -r project_name
require_not_empty project_name "プロジェクト名を指定する必要があります。"

init

chmod +x ./bin/shell-cst-prepare-backend/bin/create-backend.sh

complete_project_name="${account_id}-${prefix}-${project_name}"
shorten_project_name="${complete_project_name:0:47}"
hash=$(echo "$complete_project_name" | sha256sum | cut -d " " -f 1)
unique_suffix="${hash:0:10}"
project_id="${shorten_project_name}-${unique_suffix}"

msg "Creating backend file."
./bin/shell-cst-prepare-backend/bin/create-backend.sh --profile "$aws_profile" --region ap-northeast-1 --key "${project_id}"

cp ../settings/env.sh.default ../settings/env.sh
sed -i -e 's/export AWS_PROFILE=/export AWS_PROFILE='"${aws_profile}"'/g' ../settings/env.sh
sed -i -e 's/export PREFIX=/export PREFIX='"${prefix}"'/g' ../settings/env.sh

cd ../src/environments/dev || exit
terraform init -backend-config=../../../bin/"${project_id}".tfbackend
