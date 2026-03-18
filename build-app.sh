#!/bin/bash
set -e

echo "Building NotchKit..."
swift build -c release 2>&1

APP_DIR="dist/NotchKit.app/Contents"
rm -rf dist
mkdir -p "$APP_DIR/MacOS"
mkdir -p "$APP_DIR/Resources"

cp .build/release/NotchKit "$APP_DIR/MacOS/NotchKit"
cp NotchKit/Info.plist "$APP_DIR/Info.plist"

echo ""
echo "NotchKit.app built successfully!"
echo "Location: dist/NotchKit.app"
echo "To run:   open dist/NotchKit.app"
