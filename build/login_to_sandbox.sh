echo "Logging into Sandbox Salesforce Org"
mkdir keys
echo $SANDBOX_CERT_KEY | base64 -di > keys/server.key

echo "Authenticating org"
echo "Using app key, keys, and username"
sf auth jwt:grant --clientid "$SANDBOX_APP_KEY" --jwtkeyfile keys/server.key --username "$SANDBOX_USERNAME" --setdefaultdevhubusername -a DevHub
