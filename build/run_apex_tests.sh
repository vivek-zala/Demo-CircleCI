# Authenticate to salesforce
#echo "Authenticating..."
#sfdx force:auth:jwt:grant --clientid $APP_KEY --jwtkeyfile keys/server.key --username $SF_USERNAME --setdefaultdevhubusername -a DevHub

# Create a scratch org
echo "Creating the Scratch Org..."
sfdx org create scratch -f config/project-scratch-def.json -a ${CIRCLE_BRANCH}
# sf org generate password --target-org <username-or-alias> # Change user name
 sfdx force:user:password:generate --target-org ${CIRCLE_BRANCH}
 sfdx force:org:display --target-org ${CIRCLE_BRANCH}
#  sfdx force:user:display -target-org ${CIRCLE_BRANCH}
 

sfdx force:package:install -p 04tHo000000gxNl --target-org ${CIRCLE_BRANCH} -w 5 --security-type AllUsers
# sfdx force:package:install -p 04t3o000001QbwP --target-org ${CIRCLE_BRANCH} -w 5 --security-type AllUsers
 
sfdx force:source:push -u ${CIRCLE_BRANCH}

#echo "Coverting source to metadata format"
#sfdx force:source:convert -d test_code -r force-app

#echo "Deploying code to org"
#sfdx force:mdapi:deploy --checkonly -u DevHub -d test_code/ -w -1 -l RunLocalTests

# echo "Deploying source to org"
# sfdx force:source:deploy --sourcepath force-app --targetusername DevHub

echo "Testing code in org"
sfdx force:apex:test:run --testlevel RunLocalTests --outputdir test-results --resultformat tap --targetusername DevHub