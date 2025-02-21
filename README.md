# 📰 Quick description

Added here are some scripts I use in my projects to automate tasks 🚀

## Scripts

### 1) generate_readme [(link)](generate_readme.sh)

Auto-generate README files with project environment variables. You can choose between `Node JS` or `React Native` projects.
Run it using `curl`

```bash
/bin/bash -c "$(curl -s https://raw.githubusercontent.com/cesarak/scripts/refs/heads/main/generate_readme.sh)"
```

The script will ask you to customize your README file by adding (or not) some project information


### 1) create_release [(link)](create_release.sh)

If you are using GitHub in your projects, you can run this script to auto-generate `git tag` and `git version`.

```bash
/bin/bash -c "$(curl -s https://raw.githubusercontent.com/cesarak/scripts/refs/heads/main/generate_readme.sh)" -- [version] [release notes]
```

The `release notes` arg is optional, the `version` isn't.
