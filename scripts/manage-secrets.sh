#!/bin/bash

# Secrets Management Script

echo "Managing database secrets..."

# Extract database info
DB_HOST=$(jq -r '.[] | select(.OutputKey=="DatabaseEndpoint") | .OutputValue' /tmp/rds-outputs.json)
DB_USER=$(jq -r '.[] | select(.OutputKey=="DatabaseUsername") | .OutputValue' /tmp/rds-outputs.json)
DB_PASSWORD="123456789"
DB_NAME="lola_dev"

SECRET_NAME="db/credentials"

# Create secret JSON
SECRET_VALUE=$(cat <<EOF
{
  "username": "$DB_USER",
  "password": "$DB_PASSWORD",
  "host": "$DB_HOST",
  "schema": "$DB_NAME",
  "connector": "mysql+mysqlconnector"
}
EOF
)

# Check if secret exists
if aws secretsmanager describe-secret --secret-id "$SECRET_NAME" --region "$AWS_REGION" &>/dev/null; then
    echo "Secret exists, updating..."
    aws secretsmanager update-secret \
        --secret-id "$SECRET_NAME" \
        --secret-string "$SECRET_VALUE" \
        --region "$AWS_REGION"
else
    echo "Creating new secret..."
    aws secretsmanager create-secret \
        --name "$SECRET_NAME" \
        --description "Database credentials for DynamoHub" \
        --secret-string "$SECRET_VALUE" \
        --region "$AWS_REGION"
fi

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Secret management failed${NC}"
    exit 1
fi

# Verify secret
echo "Verifying secret..."
RETRIEVED_SECRET=$(aws secretsmanager get-secret-value \
    --secret-id "$SECRET_NAME" \
    --region "$AWS_REGION" \
    --query 'SecretString' \
    --output text)

if [[ -z "$RETRIEVED_SECRET" ]]; then
    echo -e "${RED}Could not retrieve secret${NC}"
    exit 1
fi

echo -e "${GREEN}Secret configured successfully${NC}"