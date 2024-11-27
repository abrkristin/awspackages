**Step 1. Create two .zip files:
**

zip windows_exporter windows_exporter-0.29.0-amd64.msi ./install.ps1 ./uninstall.ps1

zip node_exporter node_exporter ./install.sh ./uninstall.sh

**Step 2. Check their checksums and replace "sha256" line in **manifest.json** file:
**

sha256sum windows_exporter.zip

sha256sum node_exporter.zip

**Step 3. Upload the packages and manifest to an Amazon S3 bucket:
**

aws s3 cp windows_exporter.zip node_exporter.zip manifest.json s3://amzn-s3-your-bucket-for-packages/exporter_package/ --sse AES256

**Step 4. Create document:
**

aws ssm create-document --name "exporter" --content file://path-to-manifest-file/manifest.json --attachments Key="SourceUrl",Values="s3://amzn-s3-your-bucket-for-packages/exporter_package" --version-name 1.0.1 --document-type "Package"
