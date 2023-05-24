# Brew packages for MacOS

* Using given scripts on MacOS, user can install bundler of packages.

Example:

### List whether package insalled or not
```
brew list --cask zoom slack telegram authy google-drive google-chrome
```

### Install devops tools ( git, vscode, iTerm2, etc)
```
brew bundle --file Brewfile-devops --no-upgrade -v
```

### Install "Extra" productivity tools (browsers like chrome, firefox, brave etc, and other tools like notion, evernote, discord, slack, zoom, lastpass, etc )

```
brew bundle --file Brewfile-extra --no-upgrade -v
```

