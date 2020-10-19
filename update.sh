#!/bin/bash -xe

read_var() {
  if [ -z "$1" ]; then
    echo "environment variable name is required"
    return
  fi

  local ENV_FILE='.env'
  if [ ! -z "$2" ]; then
    ENV_FILE="$2"
  fi

  local VAR=$(grep ^$1= "$ENV_FILE" | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo ${VAR[1]}
}

aws_account_id=$(read_var aws_account_id)
subnet_id=$(read_var subnet_id)

sed -i "s/<aws_account_id>/${aws_account_id}/g" ./ssm_documents/RHEl8_AMI.yml
sed -i "s/<subnet_id>/${subnet_id}/g" ./ssm_documents/RHEl8_AMI.yml
sed -i "s/<InstallSSMAgentUserData>/`base64 -w0 ./user_data/ssm_agent_install.sh`/g" ./ssm_documents/RHEl8_AMI.yml

aws ssm update-document \
    --profile "ssmtest" \
    --region "ap-southeast-1" \
    --content file://ssm_documents/RHEL8_AMI.yml \
    --name "RHEL8_AMI" \
    --document-version \$LATEST \
    --document-format "YAML"