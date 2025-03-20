#!/bin/bash

set -e

# Build the project
npm run build
if [ $? -ne 0 ]; then
    echo "Build failed. Exiting."
    exit 1
fi

# Copy the file downloadUnzip.bash to the dist folder
if [ -f "./downloadUnzip.bash" ]; then
    if [ -d "./dist" ]; then
        cp ./downloadUnzip.bash ./dist/
        if [ $? -ne 0 ]; then
            echo "Failed to copy downloadUnzip.bash to ./dist. Exiting."
            exit 1
        fi
        echo "downloadUnzip.bash copied to ./dist successfully."
    else
        echo "Directory './dist' does not exist. Exiting."
        exit 1
    fi
else
    echo "File 'downloadUnzip.bash' does not exist in the current location. Exiting."
    exit 1
fi

# Check if the ./dist directory exists
if [ -d "./dist" ]; then
    tar -czf dist.tar.gz -C ./dist .
    if [ $? -ne 0 ]; then
        echo "Compression failed. Exiting."
        exit 1
    fi
    echo "Compression successful: dist.tar.gz created."
else
    echo "Directory './dist' does not exist. Exiting."
    exit 1
fi

# Uploaded to LightSail bucket
aws s3api put-object --bucket karoosoftware --key karoosoftware/dist --body ./dist.tar.gz --acl bucket-owner-full-control
if [ $? -ne 0 ]; then
    echo "S3 upload failed. Exiting."
    exit 1
fi
echo "dist.tar.gz uploaded successfully"

# Clean up dist.tar.gz
if [ -f "./dist.tar.gz" ]; then
    rm ./dist.tar.gz
    if [ $? -ne 0 ]; then
        echo "Failed to delete dist.tar.gz. Exiting."
        exit 1
    fi
    echo "dist.tar.gz clean successfully."
fi

echo "Script executed successfully."