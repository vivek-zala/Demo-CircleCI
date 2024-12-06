echo "Logging into Sandbox Salesforce Org"
mkdir keys
echo $SANDBOX_CERT_KEY | base64 -di > keys/server.key

echo "Removing previous .salesforce"
rm -rf ~/.salesforce
echo "Removed"

echo "Authenticating org"
echo "Using app key, keys, and username"
echo "SANDBOX_APP_KEY: SANDBOX_APP_KEY"
echo "SANDBOX_USERNAME: SANDBOX_USERNAME"

sf auth jwt:grant --clientid "SANDBOX_APP_KEY" --jwtkeyfile keys/server.key --username "SANDBOX_USERNAME" --setdefaultdevhubusername -a MyScratchOrg1
