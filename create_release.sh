#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variable definitions
VERSION=$1
NOTES=$2

# Check if version is provided
if [ -z "$VERSION" ]; then
  echo "Error: Version is required."
  exit 1
fi

# Check if notes is provided, otherwise set a default message
if [ -z "$NOTES" ]; then
  NOTES="Release notes for $VERSION"
fi

git tag $VERSION
git push origin $VERSION
gh release create $VERSION --title "Release $VERSION" --notes "$NOTES"
echo "Release $VERSION has been created and pushed."
