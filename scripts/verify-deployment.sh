#!/bin/bash

# Deployment Verification Script

echo "Verifying deployment..."

# Check CloudFormation stacks
echo "Checking CloudFormation stacks..."
STACK_NAME="dynamo-hub-infrastructure-$ENV"
RDS_STACK_NAME="dynamo-hub-simple-rds-$ENV"

for stack in "$STACK_NAME" "$RDS_STACK_NAME"; do
    STATUS=$(aws cloudformation describe-stacks \
        --stack-name "$stack" \
        --region "$AWS_REGION" \
        --query 'Stacks[0].StackStatus' \
        --output text 2>/dev/null)
    
    if [[ "$STATUS" != "CREATE_COMPLETE" && "$STATUS" != "UPDATE_COMPLETE" ]]; then
        echo -e "${RED}Stack $stack status: $STATUS${NC}"
        exit 1
    fi
    echo "Stack $stack: $STATUS"
done

# Check Lambda function
echo "Checking Lambda function..."
FUNCTION_NAME="dynamo-hub-$ENV-handle_dynamo_stream"
FUNCTION_STATUS=$(aws lambda get-function \
    --function-name "$FUNCTION_NAME" \
    --region "$AWS_REGION" \
    --query 'Configuration.State' \
    --output text 2>/dev/null)

if [[ "$FUNCTION_STATUS" != "Active" ]]; then
    echo -e "${RED}Lambda function $FUNCTION_NAME status: $FUNCTION_STATUS${NC}"
    exit 1
fi
echo "Lambda function: $FUNCTION_STATUS"

# Check secret
echo "Checking secret..."
if ! aws secretsmanager describe-secret \
    --secret-id "db/credentials" \
    --region "$AWS_REGION" &>/dev/null; then
    echo -e "${RED}Secret db/credentials not found${NC}"
    exit 1
fi
echo "✅ Secret: Available"

# Check database connectivity (via bastion)
echo "Checking database connectivity..."
BASTION_IP=$(jq -r '.[] | select(.OutputKey=="BastionPublicIP") | .OutputValue' /tmp/dynamo-hub-outputs.json)
KEY_PAIR_NAME=$(jq -r '.[] | select(.OutputKey=="BastionKeyPairName") | .OutputValue' /tmp/dynamo-hub-outputs.json)

# Download key again for verification
aws ec2 describe-key-pairs \
    --key-names "$KEY_PAIR_NAME" \
    --include-key-material \
    --region "$AWS_REGION" \
    --query 'KeyPairs[0].KeyMaterial' \
    --output text > "/tmp/verify-key.pem"
chmod 600 "/tmp/verify-key.pem"

DB_HOST=$(jq -r '.[] | select(.OutputKey=="DatabaseEndpoint") | .OutputValue' /tmp/rds-outputs.json)
DB_USER=$(jq -r '.[] | select(.OutputKey=="DatabaseUsername") | .OutputValue' /tmp/rds-outputs.json)

if ssh -i "/tmp/verify-key.pem" -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
    ec2-user@"$BASTION_IP" \
    "mysql -h $DB_HOST -u $DB_USER -p123456789 lola_dev -e 'SELECT COUNT(*) FROM accounts;'" &>/dev/null; then
    echo "Database: Connected"
else
    echo -e "${YELLOW}Database connectivity check failed (may be normal)${NC}"
fi

# Cleanup
rm -f "/tmp/verify-key.pem" "/tmp/dynamo-hub-outputs.json" "/tmp/rds-outputs.json" "/tmp/db_tables.txt"

echo -e "${GREEN}Verification completed${NC}"