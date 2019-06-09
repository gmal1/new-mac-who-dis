#!/bin/sh

echo "new mac who dis?"

# some configs reused from:
# https://github.com/nnja/new-computer
# https://github.com/ruyadorno/installme-osx

echo "Starting brew setup..."

# brew setup
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade

echo "Starting brew app install..."

### dev tools 
brew cask install iterm2

### Development
brew cask install docker
brew install postgresql
brew install redis

### Command line tools - install new ones, update others to latest version
brew install git  # upgrade to latest
brew install git-lfs # track large files in git https://github.com/git-lfs/git-lfs
brew install wget
brew install zsh # zshell
brew install grep --with-default-names
brew install trash  # move to osx trash instead of rm
brew install less
brew install neovim

### python
brew install python

### node setup
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
nvm install node
nvm use node

### npm essentials
npm install -g eslint
npm install -g concurrently
npm install -g nodemon

### code editor
brew cask install visual-studio-code

### notes 
brew cask install evernote
brew cask install notion

### utils 
brew cask install google-chrome
brew cask install firefox
brew cask install alfred
brew cask install caffeine  # keep computer from sleeping
brew cask install spotify

### chat/communication
brew cask install slack
brew cask install zoomus

### run brew cleanup
brew cleanup

echo "Installing global Python packages..."

pip3 install --upgrade pip
pip3 install --user pylint

### Set OSX Preferences - borrowed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# only show open apps in dock
defaults write com.apple.dock static-only -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# disable PowerChime on Mac 💆
defaults write http://com.apple .PowerChime ChimeOnNoHardware -bool true
killall PowerChime

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t show recent applications in Dock
#    defaults write com.apple.dock show-recents -bool false

# Menu bar: hide the Time Machine, User icons, but show the volume Icon.
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Use function F1, F, etc keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable force click and haptic feedback
defaults write ~/Library/Preferences/com.apple.AppleMultitouchTrackpad.plist ForceSuppressed -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo ""
echo "Done!" 
echo ""
echo ""
echo "################################################################################" 
echo ""
echo ""
echo "Note that some of these changes require a logout/restart to take effect." 
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ] ;then
    softwareupdate -i -a --restart
fi
