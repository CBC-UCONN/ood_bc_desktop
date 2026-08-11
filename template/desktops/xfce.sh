# Remove any preconfigured monitors
if [[ -f "${HOME}/.config/monitors.xml" ]]; then
  mv "${HOME}/.config/monitors.xml" "${HOME}/.config/monitors.xml.bak"
fi

# Copy over default panel if doesn't exist, otherwise it will prompt the user
PANEL_CONFIG="${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
if [[ ! -e "${PANEL_CONFIG}" ]]; then
  mkdir -p "$(dirname "${PANEL_CONFIG}")"
  cp "/etc/xdg/xfce4/panel/default.xml" "${PANEL_CONFIG}"
fi

# Disable startup services
xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -n -t bool -s false

# Disable useless services on autostart
AUTOSTART="${HOME}/.config/autostart"
rm -fr "${AUTOSTART}"    # clean up previous autostarts
mkdir -p "${AUTOSTART}"
for service in "pulseaudio" "rhsm-icon" "spice-vdagent" "tracker-extract" "tracker-miner-apps" "tracker-miner-user-guides" "xfce4-power-manager" "xfce-polkit"; do
  echo -e "[Desktop Entry]\nHidden=true" > "${AUTOSTART}/${service}.desktop"
done

# Run Xfce4 Terminal as login shell (sets proper TERM)
xfconf-query -c xfce4-terminal -p /misc/command-login-shell -n -t bool -s true

# Change wallpaper
url="https://ok7static.oktacdn.com/fs/bco/7/fs0tfc7m10fYickr3357"
WALLPAPER="/tmp/biohive-wallpaper.jpg"
wget -O $WALLPAPER $url

# Get the list of properties related to wallpaper
PROPERTIES=$(xfconf-query -c xfce4-desktop -l | grep last-image)

# Loop through each property and change the wallpaper
for PROP in $PROPERTIES
do
  xfconf-query -c xfce4-desktop -p $PROP -s $WALLPAPER
done
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -s false

# launch dbus first through eval becuase it can conflict with a conda environment
# see https://github.com/OSC/ondemand/issues/700
eval $(dbus-launch --sh-syntax)

# Start up xfce desktop (block until user logs out of desktop)
xfce4-session