# DynamoHub Setup

Simple deployment script for DynamoHub infrastructure and database setup.

## What This Does

1. **Deploys Infrastructure**: VPC, RDS MySQL, EC2 Bastion with Session Manager
2. **Provides Manual Steps**: For database configuration and application deployment

## Prerequisites

- AWS CLI configured with appropriate credentials
- MySQL client installed
- Docker (for DynamoHub deployment)
- **AWS Credentials**: Ensure your AWS user/role has the necessary IAM permissions (see VerizonIntegration/app/policy/policy-template.json for required permissions)

## Quick Start

### 1. Deploy Infrastructure

```bash
./deploy-complete.sh
```

This creates:
- VPC with public/private subnets
- RDS MySQL database
- EC2 Bastion host with Session Manager

### 2. Configure Database

Connect to EC2 via Session Manager:
```bash
# Get Instance ID from CloudFormation output
INSTANCE_ID=$(aws cloudformation describe-stacks --stack-name dynamo-hub-simple-rds-dev --region <region> --query 'Stacks[0].Outputs[?OutputKey==`BastionInstanceId`].OutputValue' --output text)

# Connect to EC2
aws ssm start-session --target $INSTANCE_ID --region <region>
```

Inside EC2, connect to MySQL and run the SQL commands from `complete_database_setup.sql`:

### 3. Create Database Secret

Create the database credentials secret in AWS Secrets Manager:

```bash
aws secretsmanager create-secret \
    --name "db/credentials" \
    --description "Database credentials for DynamoHub" \
    --secret-string '{
        "username": "dynamohub",
        "password": "123456789",
        "host": "dynamo-hub-dev.cxekm8qgy6vr.us-east-2.rds.amazonaws.com",
        "schema": "lola_dev",
        "connector": "mysql+mysqlconnector"
    }' \
    --region <region>
```

### 4. Deploy DynamoHub

```bash
cd ../DynamoHub
ENV=dev make deploy
```

### 5. Deploy Integrations

```bash
# Verizon Integration
cd ../VerizonIntegration
ENV=dev make deploy

# Vodafone Integration  
cd ../VodafoneIntegration
ENV=dev make deploy

# Webbing Integration
cd ../WebbingIntegration
ENV=dev make deploy
```

## Database Schema

The database includes:
- `accounts` - Customer accounts
- `carriers` - Carrier information (Verizon, Vodafone, etc.)
- `carrier_accounts` - Carrier account mappings
- `devices` - Device information
- `assignments` - Device-to-account assignments
- `rate_plans` - Billing rate plans
- `daily_data_usages` - Daily usage tracking
- `monthly_data_usages` - Monthly usage tracking

## Important Notes

- **Verizon Integration**: Uses `carrier_account_number: "verizon-default"` which maps to `carrier_account_id: 15`
- **Database Password**: `123456789` (change in production)
- **Session Manager**: No SSH keys needed, uses AWS Session Manager

## Cleanup

To remove all resources:
```bash
aws cloudformation delete-stack --stack-name dynamo-hub-simple-rds-dev --region <region>
aws cloudformation delete-stack --stack-name dynamo-hub-infrastructure-dev --region <region>
```

## AWS Credentials Setup

Ensure your AWS credentials have the required permissions. The deployer user needs:
- EC2 full access
- RDS full access  
- IAM role creation/management
- CloudFormation stack management
- Lambda function management
- VPC/Security Group management
- Secrets Manager access

Refer to `..app/policy/policy-template.json` for the complete IAM policy.

**Note**: The database secret (`db/credentials`) is created automatically during step 3 above.

## Troubleshooting

- **Permission Errors**: Ensure deployer has IAM permissions for EC2, RDS, and IAM roles
- **AMI Issues**: Template uses latest Amazon Linux 2 AMI for us-east-2
- **Database Connection**: Ensure EC2 security group allows MySQL access to RDS