#!/bin/bash

# Create or overwrite README.md
cat > README.md << 'EOF'
# Project Environment Configuration

## System Environment
EOF

# Add Node information
echo -e "\n### Node Environment" >> README.md
echo '```' >> README.md
echo "Node Version: $(node -v)" >> README.md
echo "NPM Version: $(npm -v)" >> README.md
echo "NVM Version: $(nvm --version 2>/dev/null || echo 'NVM not installed')" >> README.md
echo '```' >> README.md

# Add Ruby information
echo -e "\n### Ruby Environment" >> README.md
echo '```' >> README.md
echo "Ruby Version: $(ruby -v)" >> README.md
echo "Gem Version: $(gem -v)" >> README.md
echo "Bundler Version: $(bundler -v 2>/dev/null || echo 'Bundler not installed')" >> README.md
echo '```' >> README.md

# Add Java information
echo -e "\n### Java Environment" >> README.md
echo '```' >> README.md
java -version 2>> README.md
echo '```' >> README.md

# Add React Native information
echo -e "\n### React Native Environment" >> README.md
echo '```' >> README.md
echo "React Native CLI: $(react-native --version 2>/dev/null || echo 'React Native CLI not installed')" >> README.md
echo '```' >> README.md

# Add Package Dependencies
echo -e "\n## Package Dependencies" >> README.md
echo '```json' >> README.md
cat package.json | jq '.dependencies' >> README.md
echo '```' >> README.md

# Add Development Dependencies
echo -e "\n## Development Dependencies" >> README.md
echo '```json' >> README.md
cat package.json | jq '.devDependencies' >> README.md
echo '```' >> README.md

# Add Android SDK information
echo -e "\n## Android Configuration" >> README.md
echo '```gradle' >> README.md
echo "Compile SDK Version: $(grep 'compileSdkVersion' android/app/build.gradle | awk '{print $2}')" >> README.md
echo "Target SDK Version: $(grep 'targetSdkVersion' android/app/build.gradle | awk '{print $2}')" >> README.md
echo "Minimum SDK Version: $(grep 'minSdkVersion' android/app/build.gradle | awk '{print $2}')" >> README.md
echo '```' >> README.md

# Add Gradle information
echo -e "\n### Gradle Configuration" >> README.md
echo '```' >> README.md
cd android && ./gradlew -v >> ../README.md && cd ..
echo '```' >> README.md

# Add Environment Variables (excluding sensitive data)
echo -e "\n## Environment Variables" >> README.md
echo '```bash' >> README.md
# List all environment variables that start with REACT_NATIVE, API_, APP_, etc.
# Be careful not to expose sensitive data
env | grep -E '^(REACT_NATIVE_|API_|APP_)' | sed 's/=.*$/=***/' >> README.md
echo '```' >> README.md

# Add iOS information if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n## iOS Configuration" >> README.md
    echo '```' >> README.md
    echo "Xcode Version: $(xcodebuild -version 2>/dev/null || echo 'Xcode not installed')" >> README.md
    echo "CocoaPods Version: $(pod --version 2>/dev/null || echo 'CocoaPods not installed')" >> README.md
    echo '```' >> README.md
fi

# Add Git information
echo -e "\n## Git Configuration" >> README.md
echo '```' >> README.md
echo "Git Version: $(git --version)" >> README.md
echo "Current Branch: $(git branch --show-current)" >> README.md
echo '```' >> README.md
echo '`MobRadio® All Rights Reserved`' >> README.md

# Add timestamp
echo -e "\n\n*This README was automatically generated on $(date)*" >> README.md

echo "README.md has been generated successfully!"
