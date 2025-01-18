#!/bin/bash

# Prompt the user to choose the project type
read -p "Is this a Node.js or React Native project? (node/react): " project_type

# Check if README.md exists
if [ -f README.md ]; then
    # Prompt the user to decide whether to clear the existing README.md
    read -p "README.md already exists. Do you want to clear it? (y/n): " clear_readme
    if [[ "$clear_readme" == "y" ]]; then
        # Clear the contents of README.md
        > README.md
    fi
else
    # Create a new README.md if it doesn't exist
    touch README.md
fi

# Append initial content to README.md
cat >> README.md << 'EOF'
# Project Environment Configuration

## System Environment
EOF

if [[ "$project_type" == "node" ]]; then
    # Add Node.js environment information
    echo -e "\n### Node Environment" >> README.md
    echo '```' >> README.md
    echo "Node Version: $(node -v)" >> README.md
    echo "NPM Version: $(npm -v)" >> README.md
    echo "NVM Version: $(nvm --version 2>/dev/null || echo 'NVM not installed')" >> README.md
    echo '```' >> README.md

    # Prompt the user to decide whether to include package dependencies
    read -p "Do you want to include package dependencies? (y/n): " include_dependencies
    if [[ "$include_dependencies" == "y" ]]; then
        # Add package dependencies from package.json
        echo -e "\n## Package Dependencies" >> README.md
        echo '```json' >> README.md
        cat package.json | jq '.dependencies' >> README.md
        echo '```' >> README.md
    fi

elif [[ "$project_type" == "react" ]]; then
    # Add React Native environment information
    echo -e "\n### React Native Environment" >> README.md
    echo '```' >> README.md
    echo "React Native CLI: $(react-native --version 2>/dev/null || echo 'React Native CLI not installed')" >> README.md
    echo '```' >> README.md

    # Prompt the user to decide whether to include package dependencies
    read -p "Do you want to include package dependencies? (y/n): " include_dependencies
    if [[ "$include_dependencies" == "y" ]]; then
        # Add package dependencies from package.json
        echo -e "\n## Package Dependencies" >> README.md
        echo '```json' >> README.md
        cat package.json | jq '.dependencies' >> README.md
        echo '```' >> README.md
    fi

    # Add Android SDK configuration information
    echo -e "\n## Android Configuration" >> README.md
    echo '```gradle' >> README.md
    echo "Compile SDK Version: $(grep 'compileSdkVersion' android/app/build.gradle | awk '{print $2}')" >> README.md
    echo "Target SDK Version: $(grep 'targetSdkVersion' android/app/build.gradle | awk '{print $2}')" >> README.md
    echo "Minimum SDK Version: $(grep 'minSdkVersion' android/app/build.gradle | awk '{print $2}')" >> README.md
    echo '```' >> README.md

    # Add iOS configuration information if on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "\n## iOS Configuration" >> README.md
        echo '```' >> README.md
        echo "Xcode Version: $(xcodebuild -version 2>/dev/null || echo 'Xcode not installed')" >> README.md
        echo "CocoaPods Version: $(pod --version 2>/dev/null || echo 'CocoaPods not installed')" >> README.md
        echo '```' >> README.md
    fi
fi

# Check if GitHub Actions workflows exist and add information
if [ -d ".github/workflows" ] && [ "$(ls -A .github/workflows/*.yml 2>/dev/null)" ]; then
    echo -e "\n## GitHub Actions" >> README.md
    for workflow in .github/workflows/*.yml; do
        action_name=$(basename "$workflow" .yml)
        description=$(grep -m 1 'description:' "$workflow" | sed 's/description: //')
        echo -e "\n### $action_name" >> README.md
        if [ -n "$description" ]; then
            echo -e "$description" >> README.md
        fi
    done
fi

# Add Git submodules information
if git config --file .gitmodules --get-regexp path &>/dev/null; then
    echo -e "\n## Git Submodules" >> README.md
    git config --file .gitmodules --get-regexp path | while read -r path_key path; do
        url_key=$(echo "$path_key" | sed 's/\.path/.url/')
        url=$(git config --file .gitmodules --get "$url_key")
        echo "- $path: $url" >> README.md
    done
fi

# Add Ruby local version
if [ -f ".ruby-version" ]; then
    echo -e "\n## Ruby Local Version" >> README.md
    echo "Ruby Version: $(cat .ruby-version)" >> README.md
fi

# Add environment variables, excluding sensitive data
echo -e "\n## Environment Variables" >> README.md
echo '```bash' >> README.md
env | grep -E '^(REACT_NATIVE_|API_|APP_)' | sed 's/=.*$/=***/' >> README.md
echo '```' >> README.md

# Add Git configuration information
echo -e "\n## Git Configuration" >> README.md
echo '```' >> README.md
echo "Git Version: $(git --version)" >> README.md
echo "Current Branch: $(git branch --show-current)" >> README.md
echo '```' >> README.md

# Add a timestamp to the README.md
echo -e "\n\n*This README was automatically generated on $(date +'%Y-%m-%d %H:%M:%S')*" >> README.md
echo -e "\nIf you want to add it on your project, refer to [this link](https://github.com/cesarak/scripts)" >> README.md

# Notify the user that the README.md has been generated
echo "README.md has been generated successfully! 🎉"
