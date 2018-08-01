#!/bin/sh
# Sets (un)reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) cribbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#
# Even more from:
#    https://github.com/caarlos0/dotfiles.git
#
# The rest from extracting what I could from plists via:
#    https://www.emacswiki.org/emacs/MacOSXPlist
#
# ;; Allow editing of binary .plist files.
#    (add-to-list 'jka-compr-compression-info-list
#              ["\\.plist$"
#               "converting text XML to binary plist"
#               "plutil"
#               ("-convert" "binary1" "-o" "-" "-")
#               "converting binary plist to text XML"
#               "plutil"
#               ("-convert" "xml1" "-o" "-" "-")
#               nil nil "bplist"])
# ;;It is necessary to perform an update!
# (jka-compr-update)


if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

set +e

disable_agent() {
	mv "$1" "$1_DISABLED" >/dev/null 2>&1 ||
		sudo mv "$1" "$1_DISABLED" >/dev/null 2>&1
}

unload_agent() {
	launchctl unload -w "$1" >/dev/null 2>&1
}

sudo -v

echo ""
echo "› System:"
echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

# echo "  › Use AirDrop over every interface"
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

echo "  › Show the ~/Library folder"
chflags nohidden ~/Library

echo "  › Show the /Volumes folder"
sudo chflags nohidden /Volumes

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  › Enable text replacement almost everywhere"
defaults write -g WebAutomaticTextReplacementEnabled -bool true

echo "  › Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  ›  Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "  › Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "  › Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo "  › Enable subpixel font rendering on non-Apple LCDs"
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

echo "  › Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo "  › Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "  › Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  › Increase the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "  › Disable smart quotes and smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "  › Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  › Set up trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

echo "  > Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "  > Trackpad: map bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

echo "  > Pointing Devices: Disable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "  › Avoid the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "  › Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Set graphite appearance"
defaults write NSGlobalDomain AppleAquaColorVariant -int 6

echo "  › Set graphite highlight color"
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"

echo "  › Show battery percent"
defaults write com.apple.menuextra.battery ShowPercent -bool true

echo "  › Show the clock in 24hr format with the date"
defaults write com.apple.menuextra.clock DateFormat -string "MMM d  H:mm"

echo "  › Speed up wake from sleep to 24 hours from an hour"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
sudo pmset -a standbydelay 86400

echo "  › Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

echo "  › Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
	-kill -r -domain local -domain system -domain user

echo "  › Don't autoseek Bluetooth keyboards"
defaults write com.apple.systempreferences BluetoothAutoSeekKeyboard -bool false

echo "  › Don't autoseek Bluetooth mice"
defaults write com.apple.systempreferences BluetoothAutoSeekPointingDevice -bool false



#############################

echo ""
echo "› Finder:"
echo "  › Always open everything in Finder's list view"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

echo "  › Set the Finder prefs for showing a few different volumes on the Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  › Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  › Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  › Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "  › Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "  › Save to disk by default, instead of iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  › Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

#############################

echo ""
¡™¡™echo "› Photos:"
echo "  › Disable it from starting everytime a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################

# echo ""
# echo "› Browsers:"
# echo "  › Hide Safari's bookmark bar"
# defaults write com.apple.Safari ShowFavoritesBar -bool false

# echo "  › Disable the annoying backswipe in Chrome"
# defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

#############################

echo ""
echo "› Dock"
echo "  › Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo "  › Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

echo "  › Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0
echo "  › Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo "  › Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "  › Don't animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "  › Put the Dock on the Left"
defaults write com.apple.dock orientation -string "left"

echo "  › Hot corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
echo "    › Top left screen corner → Mission Control"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
echo "    › Top right screen corner → Desktop"
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
echo "    › Bottom left screen corner → Start screen saver"
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

#############################

echo ""
echo "› Time Machine:"
echo "  › Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

echo "  › Disable backups; disabling locally is not longer an option"
sudo tmutil Disable

echo "  › Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0

echo "  ›  Disable the sudden motion sensor as it’s not useful for SSDs"
sudo pmset -a sms 0

#############################

echo ""
echo "› Media:"

echo "  › Disable iTunes helper"
disable_agent /Applications/iTunes.app/Contents/MacOS/iTunesHelper.app
echo "  › Prevent play button from launching iTunes"
unload_agent /System/Library/LaunchAgents/com.apple.rcd.plist

# echo "  › Disable Spotify web helper"
# disable_agent ~/Applications/Spotify.app/Contents/MacOS/SpotifyWebHelper

# echo "  › Prevent Android-File-Transfer to open when a device connects"
# disable_agent "/Applications/Android File Transfer.app/Contents/Resources/Android File Transfer Agent.app"
# disable_agent "$HOME/Library/Application Support/Google/Android File Transfer/Android File Transfer Agent.app"

#############################

echo ""
echo "› Kill related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
	"Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
	"Terminal" "Photos"; do
	killall "$app" >/dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
set -e
