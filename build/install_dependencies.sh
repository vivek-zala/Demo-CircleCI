echo "install_dependencies.sh file in execution"

# Exit the command if fails.
set -e

# Printing commands for debugging.
set -x

echo "Installing Salesforce CLI"
npm install -g @salesforce/cli

echo "install_dependencies.sh file completed execution"
echo
echo