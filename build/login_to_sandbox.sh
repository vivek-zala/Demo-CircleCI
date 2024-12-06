echo "Logging into Sandbox Salesforce Org"
mkdir keys
echo $SANDBOX_CERT_KEY | base64 -di > keys/server.key

# echo "Removing previous .salesforce"
# rm -rf ~/.salesforce
# echo "Removed"

echo "Authenticating org"
echo "Using app key, keys, and username"

# sf auth jwt:grant --clientid "$SANDBOX_APP_KEY" --jwtkeyfile keys/server.key --username "$SANDBOX_USERNAME" --setdefaultdevhubusername -a MyScratchOrg1 --debug
sf org login jwt --username $USER_NAME --jwtkeyfile keys/server.key --client-id $CLIENT_ID