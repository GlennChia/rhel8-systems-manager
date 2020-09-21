# 1. Creating an ssm document (CLI)

The AWS documentation for [Create an SSM document (command line)](https://docs.aws.amazon.com/systems-manager/latest/userguide/create-ssm-document-cli.html) shows the commands needed to creating ssm document from a custom yml document

To pass parameters in, we do that during the create automation stage after the document has already been created.

Commands for creating an ssm document

```bash
aws ssm create-document ^
    --content file://RHEL8_AMI.yml ^
    --name "RHEL8_AMI" ^
    --document-type "Automation" ^
    --document-format "YAML" ^
    --tags Key=Name,Value=RHEL8 Key=Environment,Value=Dev
```

Commands for updating an ssm document

```bash
aws ssm update-document ^
    --content file://RHEL8_AMI.yml ^
    --name "RHEL8_AMI" ^
    --document-version $LATEST ^
    --document-format "YAML"
```

# 2 SSM document

## 2.1 aws:runInstances

Documentation for [aws:runInstances – Launch an EC2 instance](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-action-runinstance.html) provides relevant examples

## 2.2 User data

The first user data script installs the ssm agent

- Installing the ssm agent requires the installation url to use the correct region
- Before conversion, set the user data script to the correct region

To convert the user data scripts to base 64, run `base64 -w0 <script_name>.sh`

Command to edit the parameter in the step directly (archive). We are taking the approach of adding it as the default value

```bash
sed -i "s/'{{ InstallSSMAgentUserData }}'/`base64 -w0 ssm_agent_install.sh`/g" RHEl8_AMI.yaml
```
