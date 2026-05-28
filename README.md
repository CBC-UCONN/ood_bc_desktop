# Batch Connect - Desktop

## Installing dependencies 

```bash
wget -q -O- https://packagecloud.io/dcommander/turbovnc/gpgkey |   gpg --dearmor >/etc/apt/trusted.gpg.d/TurboVNC.gpg
wget https://raw.githubusercontent.com/TurboVNC/repo/main/TurboVNC.list
ls /etc/apt/sources.list.d
mv TurboVNC.list /etc/apt/sources.list.d
apt update
apt install turbovnc
apt install websockify
apt install xfce4
apt remove xfce4-screensaver
```

Need to remove screensaver to resolve timeout issue.