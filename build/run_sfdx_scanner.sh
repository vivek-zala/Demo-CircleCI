echo "Installing JDK"
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --set java /usr/lib/jvm/jdk1.8.0_version/bin/java

echo "Install SF Scanner"
echo -e 'y/n' | sf plugins:install @salesforce/sf-scanner

echo "Running SF Scanner"
npx sf scanner:run --target "**/default/**" --format "csv" --outfile "sfScannerAnalysis.csv" --violations-cause-error
