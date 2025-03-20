#!/bin/bash

# Download from LightSail bucket
aws s3api get-object --bucket karoosoftware --key karoosoftware/dist ./dist.tar.gz
if [ $? -ne 0 ]; then
    echo "Bucket download failed. Exiting."
    exit 1
fi
echo "dist.tar.gz downloaded successfully"

# Extract the tar.gz file to the specified location
tar -xzf dist.tar.gz -C /usr/share/nginx/html
if [ $? -ne 0 ]; then
    echo "Extraction failed. Exiting."
    exit 1
fi
echo "dist.tar.gz extracted successfully to /usr/share/nginx/html"

# Copy the script to the current directory and overwrite if it exists
mv /usr/share/nginx/html/downloadUnzip.bash ./downloadUnzip.bash
if [ $? -ne 0 ]; then
    echo "Failed to copy the file. Exiting."
    exit 1
fi
echo "File copied successfully to the current directory"

# Make the copied file executable
chmod +x ./downloadUnzip.bash
if [ $? -ne 0 ]; then
    echo "Failed to make the file executable. Exiting."
    exit 1
fi
echo "File made executable successfully"

# Delete the tar.gz file
rm -f dist.tar.gz
if [ $? -ne 0 ]; then
    echo "Failed to delete dist.tar.gz. Exiting."
    exit 1
fi
echo "dist.tar.gz deleted successfully"