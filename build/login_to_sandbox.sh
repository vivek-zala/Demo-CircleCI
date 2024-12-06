echo "Logging into Sandbox Salesforce Org"
mkdir keys

# echo "Removing previous .salesforce"
# rm -rf ~/.salesforce
# echo "Removed"

echo "Authenticating org"
echo "Using app key, keys, and username"
export SFDX_CLI_DEBUG=true
sf auth jwt:grant --client-id "$SANDBOX_APP_KEY" --jwt-key-file keys/server.key --username "$SANDBOX_USERNAME" --setdefaultdevhubusername -a MyScratchOrg1 --loglevel DEBUG
