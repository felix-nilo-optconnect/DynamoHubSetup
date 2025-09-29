#!/bin/bash

# Prerequisites Check Script

echo "Checking AWS CLI..."
if ! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI not found${NC}"
    exit 1
fi

echo "Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}AWS credentials not configured${NC}"
    exit 1
fi

echo "Checking required environment variables..."
if [[ -z "$ENV" || -z "$AWS_REGION" ]]; then
    echo -e "${RED}Required environment variables not set${NC}"
    echo "Please set: ENV, AWS_REGION"
    exit 1
fi

echo "Checking MySQL client..."
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}MySQL client not found - database operations may require bastion${NC}"
fi

echo "Checking required files..."
REQUIRED_FILES=(
    "$SCRIPT_DIR/dynamo-hub-infrastructure.yml"
    "$SCRIPT_DIR/simple-rds.yml"
    "$SCRIPT_DIR/complete_database_setup.sql"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Required file not found: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}All prerequisites met${NC}"