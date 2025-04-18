#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "Cleaning previous build..."
rm -rf package
rm -f ../lambda_function.zip

echo "Installing dependencies..."
pip install -r requirements.txt --target package

echo "Creating deployment package..."
cp lambda_function.py package/

cd package
zip -r9 ../lambda_function.zip .
cd ..

rm -rf package
echo "Lambda package built at ../lambda_function.zip"
