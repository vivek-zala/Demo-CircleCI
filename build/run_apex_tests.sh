# Authenticate to salesforce
#echo "Authenticating..."
#sf auth jwt:grant --clientid $APP_KEY --jwtkeyfile keys/server.key --username $SF_USERNAME --setdefaultdevhubusername -a DevHub
echo "WElcome"

# echo "Uninstalling the packages..."
# sf package:uninstall --package 04tHo000000gxNl
# sf package:uninstall --package 04t3o000001QbwP
# echo "Unisnstalled"

# Create a scratch org
echo "Creating the Scratch Org..."
sf org create scratch -f config/project-scratch-def.json -a ${CIRCLE_BRANCH}
# sf org generate password --target-org <username-or-alias> # Change user name
 sf force:user:password:generate --target-org ${CIRCLE_BRANCH}
 sf force:org:display --target-org ${CIRCLE_BRANCH}
#  sf force:user:display -target-org ${CIRCLE_BRANCH}

echo y | sf force:package:install -p 04tHo000000gxNl --target-org ${CIRCLE_BRANCH} -w 15 --security-type AllUsers
sf force:package:install -p 04t3o000001QbwP --target-org ${CIRCLE_BRANCH} -w 15 --security-type AllUsers

# sf force:source:push -u ${CIRCLE_BRANCH}
sf project deploy start -u ${CIRCLE_BRANCH}


#echo "Converting source to metadata format"
#sf force:source:convert -d test_code -r force-app

#echo "Deploying code to org"
#sf force:mdapi:deploy --checkonly -u DevHub -d test_code/ -w -1 -l RunLocalTests

# echo "Deploying source to org"
# sf force:source:deploy --sourcepath force-app --targetusername DevHub

echo "Testing code in org"
# sf apex run test -u ${CIRCLE_BRANCH}
sf force:apex:test:run --testlevel RunLocalTests --outputdir test-results --resultformat tap --targetusername DevHub
