# shellcheck disable=SC2164
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ ! -e ../settings/env.sh ]]; then
    echo "env.sh is not found."
    exit 1
fi

source ../settings/env.sh

# Pass terraform variables from env.sh
export TF_VAR_aws_profile=$AWS_PROFILE
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_prefix=$PREFIX
export TF_VAR_owner=$OWNED_BY

# Terraform log
export TF_LOG=$TERRAFORM_LOG_LEVEL
export TF_LOG_PATH=terraform.log
