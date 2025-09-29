# DynamoHub Setup

This directory contains CloudFormation templates and scripts to set up the complete DynamoHub infrastructure from scratch.

## Quick Start

```bash
# Set environment variables
export ENV=dev
export AWS_REGION=us-east-2

# Deploy everything
./deploy-complete.sh
```

See [README-deployment.md](README-deployment.md) for detailed documentation.

## Files

### Core Templates
- `simple-rds.yml` - CloudFormation template for RDS MySQL database
- `dynamo-hub-infrastructure.yml` - CloudFormation template for DynamoHub infrastructure
- `complete_database_setup.sql` - Complete SQL script to create all required tables and data

### Deployment System
- `deploy-complete.sh` - Master deployment script
- `scripts/` - Individual deployment steps
- `README-deployment.md` - Detailed deployment guide

## Rollback

```bash
export ENV=dev
export AWS_REGION=us-east-2
./scripts/rollback.sh
```