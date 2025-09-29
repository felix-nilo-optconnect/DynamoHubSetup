#!/bin/bash

# Rollback Script

set -e

echo -e "${YELLOW}Rolling back DynamoHub deployment${NC}"

STACK_NAME="dynamo-hub-infrastructure-$ENV"
RDS_STACK_NAME="dynamo-hub-simple-rds-$ENV"

# Delete Lambda function
echo "Deleting Lambda function..."
FUNCTION_NAME="dynamo-hub-$ENV-handle_dynamo_stream"
aws lambda delete-function \
    --function-name "$FUNCTION_NAME" \
    --region "$AWS_REGION" 2>/dev/null || echo "Lambda function not found"

# Delete CloudFormation stacks
echo "Deleting CloudFormation stacks..."
aws cloudformation delete-stack \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION" 2>/dev/null || echo "Infrastructure stack not found"

aws cloudformation delete-stack \
    --stack-name "$RDS_STACK_NAME" \
    --region "$AWS_REGION" 2>/dev/null || echo "RDS stack not found"

# Wait for deletion
echo "Waiting for stack deletion..."
aws cloudformation wait stack-delete-complete \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION" 2>/dev/null || echo "Infrastructure stack deletion complete"

aws cloudformation wait stack-delete-complete \
    --stack-name "$RDS_STACK_NAME" \
    --region "$AWS_REGION" 2>/dev/null || echo "RDS stack deletion complete"

# Delete secret
echo "Deleting secret..."
aws secretsmanager delete-secret \
    --secret-id "db/credentials" \
    --force-delete-without-recovery \
    --region "$AWS_REGION" 2>/dev/null || echo "Secret not found"

echo -e "${GREEN}Rollback completed${NC}"