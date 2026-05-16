# AWS Commands and Operations

## IAM and Authentication

### Switch AWS Roles/Profiles

```bash
AWS_PROFILE=test@test.com aws sts get-caller-identity
```

Output:
```
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

Output:
```
{
    "UserId": "XXXXXXXXXXXXXXXXXX",
    "Account": "XXXXXXXXXXXX",
    "Arn": "arn:aws:iam::XXXXXXXXXXXX:user/test@test.com"
}
```

## CloudFormation

### List Stacks

```bash
aws cloudformation list-stacks
```

### Describe Stack

```bash
aws cloudformation describe-stacks --stack-name eksctl-tme-cluster
```

## Route 53

### List Hosted Zones

```bash
aws route53 list-hosted-zones
```

### List Resource Record Sets

```bash
aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXXXXXXX | grep dario
```

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

## gcloud Components

### Revert gcloud to Previous Version

```bash
gcloud components update --version 413.0.0
```
