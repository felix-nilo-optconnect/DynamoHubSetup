#!/bin/bash

# Application Deployment Script

echo "Preparing application deployment..."

# Extract infrastructure info for environment variables
LAMBDA_SG=$(jq -r '.[] | select(.OutputKey=="LambdaSecurityGroup") | .OutputValue' /tmp/dynamo-hub-outputs.json)
DB_SUBNET=$(jq -r '.[] | select(.OutputKey=="DatabaseSubnet") | .OutputValue' /tmp/dynamo-hub-outputs.json)

if [[ -z "$LAMBDA_SG" || -z "$DB_SUBNET" ]]; then
    echo -e "${RED}Could not get infrastructure information${NC}"
    exit 1
fi

# Create environment file for DynamoHub
ENV_FILE="$SCRIPT_DIR/../DynamoHub/envs/$ENV"
mkdir -p "$(dirname "$ENV_FILE")"

cat > "$ENV_FILE" <<EOF
AWS_REGION=$AWS_REGION
ENV=$ENV
LAMBDA_SG=$LAMBDA_SG
DB_SUBNET=$DB_SUBNET
EOF

echo "Environment file created: $ENV_FILE"

# Deploy DynamoHub
echo "Deploying DynamoHub application..."
cd "$SCRIPT_DIR/../DynamoHub"

# Export environment variables and deploy
export ENV=$ENV
export LAMBDA_SG=$LAMBDA_SG
export DB_SUBNET=$DB_SUBNET
make deploy

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Application deployment failed${NC}"
    exit 1
fi

echo -e "${GREEN}Application deployed successfully${NC}"