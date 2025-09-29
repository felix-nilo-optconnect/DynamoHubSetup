# DynamoHub Deployment Guide

## Quick Start

```bash
# Set environment variables
export ENV=dev
export AWS_REGION=us-east-2

# Deploy everything
./deploy-complete.sh
```

## Scripts Overview

### Main Scripts
- `deploy-complete.sh` - Master deployment script that runs everything
- `scripts/rollback.sh` - Complete rollback and cleanup

### Individual Steps
- `scripts/check-prerequisites.sh` - Validates environment and dependencies
- `scripts/deploy-infrastructure.sh` - Deploys CloudFormation stacks
- `scripts/setup-database.sh` - Creates database schema and data
- `scripts/manage-secrets.sh` - Creates/updates AWS Secrets Manager
- `scripts/deploy-application.sh` - Deploys DynamoHub Lambda
- `scripts/verify-deployment.sh` - Validates entire deployment

## Features

✅ **Prerequisites Check** - Validates AWS CLI, credentials, and required files
✅ **Error Handling** - Stops on first error with clear messages
✅ **Rollback Support** - Complete cleanup script
✅ **Verification** - Validates all components after deployment
✅ **Secrets Management** - Automatically creates `db/credentials` secret
✅ **Dependency Order** - Deploys components in correct sequence

## Environment Variables

Required:
- `ENV` - Environment name (dev, prod, etc.)
- `AWS_REGION` - AWS region for deployment

## Rollback

```bash
# Complete rollback
export ENV=dev
export AWS_REGION=us-east-2
./scripts/rollback.sh
```

## Troubleshooting

### Common Issues

1. **AWS Credentials**: Ensure AWS CLI is configured
2. **Permissions**: Verify IAM permissions for CloudFormation, Lambda, RDS, Secrets Manager
3. **Region**: Ensure all resources are in the same region
4. **Dependencies**: Run prerequisites check first

### Manual Verification

```bash
# Check stacks
aws cloudformation list-stacks --region us-east-2

# Check Lambda
aws lambda list-functions --region us-east-2

# Check secret
aws secretsmanager list-secrets --region us-east-2
```