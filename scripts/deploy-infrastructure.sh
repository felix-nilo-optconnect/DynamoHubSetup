#!/bin/bash

# Infrastructure Deployment Script

STACK_NAME="dynamo-hub-infrastructure-$ENV"
RDS_STACK_NAME="dynamo-hub-simple-rds-$ENV"

echo "Deploying DynamoHub infrastructure first..."
aws cloudformation deploy \
    --template-file "$SCRIPT_DIR/dynamo-hub-infrastructure-simple.yml" \
    --stack-name "$STACK_NAME" \
    --parameter-overrides \
        Environment="$ENV" \
    --capabilities CAPABILITY_IAM \
    --region "$AWS_REGION" \
    --no-fail-on-empty-changeset

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Infrastructure deployment failed${NC}"
    exit 1
fi

echo "Deploying RDS infrastructure..."
aws cloudformation deploy \
    --template-file "$SCRIPT_DIR/simple-rds.yml" \
    --stack-name "$RDS_STACK_NAME" \
    --parameter-overrides \
        Environment="$ENV" \
    --capabilities CAPABILITY_IAM \
    --region "$AWS_REGION" \
    --no-fail-on-empty-changeset

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Infrastructure deployment failed${NC}"
    exit 1
fi

# Wait for stacks to be ready
echo "Waiting for infrastructure to be ready..."
aws cloudformation wait stack-create-complete \
    --stack-name "$RDS_STACK_NAME" \
    --region "$AWS_REGION"

aws cloudformation wait stack-create-complete \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION"

echo -e "${GREEN}Infrastructure deployed successfully${NC}"

# Export stack outputs for later use
echo "Exporting stack outputs..."
aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION" \
    --query 'Stacks[0].Outputs' \
    --output json > "/tmp/dynamo-hub-outputs.json"

aws cloudformation describe-stacks \
    --stack-name "$RDS_STACK_NAME" \
    --region "$AWS_REGION" \
    --query 'Stacks[0].Outputs' \
    --output json > "/tmp/rds-outputs.json"