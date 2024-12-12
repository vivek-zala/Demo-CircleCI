echo "run_apex_test.sh file in execution"

# Installing the packages with package ID and waiting time of 25 minutes.
# echo y | sf force:package:install -p 04tHo000000gxNl --target-org ${CIRCLE_BRANCH} -w 25 --security-type AllUsers
# sf force:package:install -p 04t3o000001QbwP --target-org ${CIRCLE_BRANCH} -w 25 --security-type AllUsers

# Deploying the poject to scratch org.
sf project deploy start --target-org ${CIRCLE_BRANCH}

# Testing the deployed project.
echo "Testing the code in org"
sf apex run test --target-org ${CIRCLE_BRANCH}

echo "run_apex_tests.sh file completed execution"