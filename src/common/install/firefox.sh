#!/usr/bin/env bash
set -e

echo "Install Firefox"

# Does not work in Ubuntu, Centos unclear
function disableUpdate(){
    ff_def="$1/browser/defaults/profile"
    mkdir -p $ff_def
    echo "//" > $ff_def/user.js
    echo "user_pref("app.update.auto", false);" >> $ff_def/user.js
    echo "user_pref("app.update.enabled", false);" >> $ff_def/user.js
    echo "user_pref("app.update.lastUpdateTime.addon-background-update-timer", 1182011519);" >> $ff_def/user.js
    echo "user_pref("app.update.lastUpdateTime.background-update-timer", 1182011519);" >> $ff_def/user.js
    echo "user_pref("app.update.lastUpdateTime.blocklist-background-update-timer", 1182010203);" >> $ff_def/user.js
    echo "user_pref("app.update.lastUpdateTime.microsummary-generator-update-timer", 1222586145);" >> $ff_def/user.js
    echo "user_pref("app.update.lastUpdateTime.search-engine-update-timer", 1182010203);" >> $ff_def/user.js
}

# Does not work in Ubuntu, Centos unclear
function setDefault(){
    ff_cfg="$1/mozilla.cfg"
    echo "//" > $ff_cfg
    echo "lockPref("browser.startup.homepage"), "http://www.google.com");" >> $ff_cfg
    echo "lockPref("app.update.enabled", false);" >> $ff_cfg
    echo "lock_pref("browser.tabs.remote.autostart", false);" >>$ff_cfg
    
    ff_autocfg="$1/defaults/pref/autoconfig.js"
    echo "//" > $ff_autocfg
    echo "pref("general.config.obscure_value", 0);" >> $ff_autocfg
    echo "pref("general.config.filename", "mozilla.cfg");" >>$ff_autocfg
}

function addMenuItem() {
cat > /usr/share/applications/firefox.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Firefox Web Browser
Name[de]=Firefox - internetbrowser
Name[en_GB]=Firefox Web Browser
Comment=Browse the World Wide Web
Comment[de]=Im Internet surfen
GenericName=Web Browser
GenericName[de]=Webbrowser
Keywords=Internet;WWW;Browser;Web;Explorer
Keywords[de]=Internet;WWW;Browser;Web;Explorer;Webseite;Site;surfen;online;browsen
Exec=firefox %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/lib/firefox/browser/chrome/icons/default/default64.png
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
Actions=NewWindow;NewPrivateWindow;
[Desktop Action NewWindow]
Name=Open a New Window
Name[de]=Ein neues Fenster öffnen
Exec=firefox -new-window
OnlyShowIn=Unity;
[Desktop Action NewPrivateWindow]
Name=Open a New Private Window
Name[de]=Ein neues privates Fenster öffnen
Exec=firefox -private-window
OnlyShowIn=Unity;
EOF
}

#copy from org/sakuli/common/bin/installer_scripts/linux/install_firefox_portable.sh
function instFF() {
    if [ ! "${1:0:1}" == "" ]; then
        FF_VERS=$1
        if [ ! "${2:0:1}" == "" ]; then
            FF_INST=$2
            echo "download Firefox $FF_VERS and install it to '$FF_INST'."
            mkdir -p "$FF_INST"
            FF_URL=http://releases.mozilla.org/pub/firefox/releases/$FF_VERS/linux-x86_64/en-US/firefox-$FF_VERS.tar.bz2
            echo "FF_URL: $FF_URL"
            wget -qO- $FF_URL | tar xvj --strip 1 -C $FF_INST/
            ln -s "$FF_INST/firefox" /usr/bin/firefox
            setDefault $FF_INST
            addMenuItem
            exit $?
        fi
    fi
    echo "function parameter are not set correctly please call it like 'instFF [version] [install path]'"
    exit -1
}

instFF '60.2.0esr' '/usr/lib/firefox'
