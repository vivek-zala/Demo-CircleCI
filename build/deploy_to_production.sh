echo "deploy_to_production.sh file in execution"
# Exit immediately if a command exits with a non-zero status
set -e

# Authenticate to the Salesforce production org
echo "Authenticating to Production Org..."
sf org login jwt --username $PROD_USERNAME --jwt-key-file keys/server.key --client-id $PROD_CLIENT_ID -a ProductionOrg

# Deploy metadata to the production org
echo "Deploying to Production Org..."
sf project deploy start --target-org ProductionOrg

# Run Apex tests to validate the deployment
echo "Running Apex tests in Production Org..."
sf apex run test --target-org ProductionOrg

echo "Deployment to Production completed successfully."
echo "deploy_to_production.sh file completed execution"
echo
echo