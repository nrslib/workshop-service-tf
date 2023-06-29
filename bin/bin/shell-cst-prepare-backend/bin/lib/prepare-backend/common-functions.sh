val() {
  eval "$1"='"$OPTARG"'
}

val2() {
  eval "$1"='"${2}"'
}

init() {
  if [ -n "$profile" ]; then
    arg_aws_option_profile="--profile $profile"
  fi

  if [ -n "$region" ]; then
    arg_aws_option_region="--region $region"
  fi

  info
}

info() {
  cat <<EOS
----------
Information
----------
key:                    "$key"
profile:                "$profile"
region:                 "$region"
tags:                   "$tags"
bucket_name:            "$bucket_name"
table_name:             "$table_name"
arg_aws_option_profile: "$arg_aws_option_profile"
arg_aws_option_region:  "$arg_aws_option_region"
==========

EOS
}

usage() {
  cat <<EOS
usage: $(basename "$0") [--table <table_name>] [--bucket <s3_bucket_name>] [--profile <aws_profile>]
EOS
}

msg() {
  echo
  echo "-----"
  echo "$1"
  echo "-----"
}

require_not_empty_option() {
  eval "value=\$$1"
  eval "option_name=\$$2"
  if [ -z "$value" ]; then
    echo "'$2' is required option ($0})."
    exit 1
  fi
  return 0
}

while getopts "k:t:p:r:-:h" opt; do
  case "$opt" in
    -)
      case "${OPTARG}" in
        key)
          val2 key "${!OPTIND}"
          OPTIND=$(( $OPTIND + 1 ))
          ;;
        help)
          usage
          ;;
        tags)
          val2 tags "${!OPTIND}"
          OPTIND=$(( $OPTIND + 1 ))
          ;;
        profile)
          val2 profile "${!OPTIND}"
          OPTIND=$(( $OPTIND + 1 ))
          ;;
        region)
          val2 region "${!OPTIND}"
          OPTIND=$(( $OPTIND + 1 ))
          ;;
        *)
          echo "'--$OPTARG'" is not a option.
          exit 1
          ;;
      esac
      ;;
    k)
      val key
      ;;
    h)
      usage
      ;;
    t)
      val tags
      ;;
    p)
      val profile
      ;;
    r)
      val region
      ;;
    *)
      echo "-$opt" is not a option.
      exit 1
      ;;
  esac
done