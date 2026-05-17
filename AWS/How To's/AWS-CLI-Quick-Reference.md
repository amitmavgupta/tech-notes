# AWS CLI Quick Reference

A collection of essential AWS CLI commands for common operations and troubleshooting.

---

## IAM and Authentication

### Switch AWS Roles/Profiles

```bash
AWS_PROFILE=test@test.com aws sts get-caller-identity
```

**Output:**
```json
{
    "UserId": "XXXXXXXXXXXXXXXXXX:test@test.com",
    "Account": "XXXXXXXXXXXX",
    "Arn": "arn:aws:sts::XXXXXXXXXXXX:assumed-role/PowerUserAccessRole/test@test.com"
}
```

### Get Caller Identity

```bash
aws sts get-caller-identity
```

**Output:**
```json
{
    "UserId": "XXXXXXXXXXXXXXXXXX",
    "Account": "XXXXXXXXXXXX",
    "Arn": "arn:aws:iam::XXXXXXXXXXXX:user/test@test.com"
}
```

### Detach IAM Policy from IAM Role

```bash
aws iam detach-role-policy --role-name "testrole" --policy-arn "arn:aws:iam::aws:policy/testpolicy"
```

### Delete an IAM Role

```bash
aws iam delete-role --role-name "testrole"
```

---

## CloudFormation

### List Stacks

```bash
aws cloudformation list-stacks
```

### Describe Stack

```bash
aws cloudformation describe-stacks --stack-name eksctl-tme-cluster
```

### Delete CloudFormation Stack

```bash
aws cloudformation delete-stack --stack-name "teststack"
```

---

## Route 53

### List Hosted Zones

```bash
aws route53 list-hosted-zones
```

### List Resource Record Sets

```bash
aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXXXXXXX | grep dario
```

---

## Container Registry (ECR)

### Delete ECR Repository

```bash
aws ecr delete-repository \
    --repository-name ubuntu \
    --force
```

---

## Network and Availability Zones

### List IPv4 Prefixes Allocated to Each ENI

```bash
aws ec2 describe-network-interfaces --network-interface-ids eni-0f033157f5c799381 | grep Ipv4Prefix
```

### List Secondary IPv4 Addresses on EC2 Instance

```bash
aws ec2 describe-instances --instance-ids i-095018359fe01e168 | jq -r '.Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress'
```

### List Availability Zones in an AWS Region

```bash
aws ec2 describe-availability-zones --region <region-name>
```

### Find Regions Supporting EFA Adapter Type

```bash
aws ec2 describe-instance-types \
  --region us-east-1 \
  --filters Name=network-info.efa-supported,Values=true \
  --query "InstanceTypes[*].[InstanceType]" \
  --output text | sort
```

---

## AWS Quota Checker

### Install AWS Quota Checker

```bash
pip install aws-quota-checker
```

### Check VPC Count Quota

```bash
aws-quota-checker check vpc_count
```

### Check All Quotas

```bash
aws-quota-checker check all
```

---

## gcloud Components

### Revert gcloud to Previous Version

```bash
gcloud components update --version 413.0.0
```

---

## Notes

- All commands use the AWS CLI v2 format
- Ensure you have appropriate AWS credentials configured
- Use `AWS_PROFILE` environment variable to switch between different AWS profiles
- For JSON output parsing, `jq` is recommended
