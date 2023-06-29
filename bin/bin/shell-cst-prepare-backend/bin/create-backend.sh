#!/usr/bin/env bash

launch_directory=$(pwd)
shell_directory="$(dirname "${BASH_SOURCE:-$0}")"
cd "$shell_directory"
source ./lib/prepare-backend/common-functions.sh

bucket_name="tfst-${key}"
table_name="tflk-${key}"

init

require_not_empty_option key -k,--key

if [ -n "$profile" ]; then
  aws_user_id=$(aws sts get-caller-identity --profile "$profile" | jq ".UserId" | tr -d '"')
else
  aws_user_id=$(aws sts get-caller-identity | jq ".UserId" | tr -d '"')
fi

msg "creating dynamodb table."

aws dynamodb create-table $arg_aws_option_profile $arg_aws_option_region \
  --table-name "$table_name" \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --billing-mode PAY_PER_REQUEST \
  --tags Key=Owner,Value="${aws_user_id}"

msg "creating s3 bucket."
aws s3 mb s3://"$bucket_name" $arg_aws_option_profile $arg_aws_option_region

msg "setting s3 versioning."
aws s3api put-bucket-versioning $arg_aws_option_profile $arg_aws_option_region \
  --bucket "${bucket_name}" \
  --versioning-configuration Status=Enabled


if [ -n "$tags" ]; then
  tokens=(${tags//,/ })
  echo $tokens
  for i in "${!tokens[@]}"
  do
    key_value=(${tokens[i]//=/ })
    tagsets[i]="{Key=${key_value[0]},Value=${key_value[1]}}"
  done

  extra_tagsets=,$(IFS=","; echo "${tagsets[*]}")
fi

msg "tagging s3."
aws s3api put-bucket-tagging $arg_aws_option_profile \
  --bucket "${bucket_name}" \
  --tagging "TagSet=[{Key=Owner,Value=${aws_user_id}},{Key=Key,Value=${key}},{Key=Region,Value=${region}},{Key=BucketName,Value=${bucket_name}},{Key=TableName,Value=${table_name}}${extra_tagsets}]"


msg "creating tfbackend file."
cat <<EOS > "$launch_directory"/"${key}".tfbackend
region         = "${region}"
profile        = "${profile}"
key            = "${key}"
bucket         = "${bucket_name}"
dynamodb_table = "${table_name}"
encrypt        = true
EOS

echo "=== finished."