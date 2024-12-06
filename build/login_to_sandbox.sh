echo "Logging into Sandbox Salesforce Org"
mkdir keys
echo $SANDBOX_CERT_KEY | base64 -di > keys/server.key

# Ensure the key is in RSA format (if necessary)
openssl rsa -in keys/server.key -out keys/server.key

# echo "Removing previous .salesforce"
# rm -rf ~/.salesforce
# echo "Removed"

echo "Authenticating org"

# sf auth jwt:grant --clientid "$SANDBOX_APP_KEY" --jwtkeyfile keys/server.key --username "$SANDBOX_USERNAME" --setdefaultdevhubusername -a MyScratchOrg1 --debug
sf org login jwt --username $USER_NAME --jwt-key-file keys/server.key --client-id $CLIENT_ID -a DevHub --setdefaultdevhubusername

# sf auth jwt:grant --clientid "3MVG9KI2HHAq33RxgA0Kt69Kpii7Jakg3403c0jr.DW1wAzUn3lx8BLoxHoOkyYIvlvVIlJvag50wrrA1dRJ1" --jwt-key-file C:\Users\Vivek\Documents\CertificateGeneration\server.key --username "nilesh.badrakiya@gmail.com" --setdefaultdevhubusername -a MyScratchOrg1
#
#https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9KI2HHAq33RxgA0Kt69Kpii7Jakg3403c0jr.DW1wAzUn3lx8BLoxHoOkyYIvlvVIlJvag50wrrA1dRJ1&redirect_uri=http://localhost:1717/OauthRedirect
echo "Done"