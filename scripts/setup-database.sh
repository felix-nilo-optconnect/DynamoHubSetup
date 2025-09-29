#!/bin/bash

# Database Setup Script

echo "Getting database connection info..."

# Extract database info from stack outputs
DB_HOST=$(jq -r '.[] | select(.OutputKey=="DatabaseEndpoint") | .OutputValue' /tmp/rds-outputs.json)
DB_USER=$(jq -r '.[] | select(.OutputKey=="DatabaseUsername") | .OutputValue' /tmp/rds-outputs.json)
DB_PASSWORD="123456789"  # Default password from template
DB_NAME="lola_dev"

if [[ -z "$DB_HOST" ]]; then
    echo -e "${RED}Could not get database information${NC}"
    exit 1
fi

echo "Database Host: $DB_HOST"

# Setup database schema using existing EC2 instance
echo "Setting up database schema..."
echo "Please run the following command from an EC2 instance with MySQL client:"
echo "mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD < complete_database_setup.sql"
echo ""
echo "Database setup completed - manual step required"

