echo "deploy_to_qa.sh file in execution"
# Perfoming dry-run before.
sf project deploy start --checkonly --target-org ${CIRCLE_BRANCH}

# If validation passes, then pusing the code to org.
# sf project deploy start --target-org ${CIRCLE_BRANCH}

echo "deploy_to_qa.sh file completed execution"
echo
echo
