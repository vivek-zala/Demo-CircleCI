echo "Installing JDK"
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --set java /usr/lib/jvm/jdk1.8.0_version/bin/java

echo "Install SFDX Scanner"
echo -e 'y/n' | sfdx plugins:install @salesforce/sfdx-scanner

echo "Running SFDX Scanner"
npx sfdx scanner:run --target "**/default/**" --format "csv" --outfile "sfdxScannerAnalysis.csv" --violations-cause-error