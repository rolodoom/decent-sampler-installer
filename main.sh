#!/bin/bash
#  _______   _______
# |  _____| |  ___  |
# | |       | |   | |    Rolando Ramos Torres (@rolodoom)
# | |       | |___| |    http://rolandoramostorres.com
# |_|       |_______|
#  _         _______
# | |       |  ___  |
# | |       | |   | |    Install script
# | |_____  | |___| |    for Decent Sampler
# |_______| |_______|    Tested on Manjaro
#
#
#
#

# test for required commands
#command -v unzip >/dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Aborting."; exit 1; }

TEMPDIR=$(readlink -f "@temp")
VST=$(readlink -f "/usr/lib/vst")
VST3=$(readlink -f "/usr/lib/vst3")
APPBIN=$(readlink -f "/opt/DecentSampler")

# install subrutine
aa_install () {
    echo "installing..."

    # installing required libcurl-gnutls
    # sudo pacman -S libcurl-gnutls

    # check if @temp exists
    if [ ! -d "$TEMPDIR" ]; then
        # Create dir if doesn't exists
        mkdir @temp
        # Unzip Sofware
        tar -xf Decent*.tar.gz -C "$TEMPDIR"
        
    fi

    # clean mac Files from installers
    find "$TEMPDIR" -name '.DS_Store' -exec rm -rf {} \;

    # copy VST files
    sudo cp -r "$TEMPDIR"/Decent*/DecentSampler.so "$VST"
        sudo cp -r "$TEMPDIR"/Decent*/DecentSampler.vst3 "$VST3"

    # check if /opt/DecentSampler exists
    if [ ! -d "$APPBIN" ]; then
    # Create dir if doesn't exists
        sudo mkdir "$APPBIN"
    fi

    # copy Stand Alone
    sudo cp -r "$TEMPDIR"/Decent*/DecentSampler "$APPBIN"


    #chmod 777
    sudo chmod +x "$APPBIN"/DecentSampler


    #usr/local/bin links

    sudo ln -s "$APPBIN"/DecentSampler "/usr/local/bin/DecentSampler"

    # copy .local files
    sudo cp -r usr/share /usr

    # Remove @temp
    sudo rm -rf "$TEMPDIR"

    echo "Done!!!"
}

# uninstall subrutine
aa_uninstall () {
    echo "Uninstalling..."

    # @temp
    sudo rm -rf "$TEMPDIR"

    # desktop files

    sudo rm -rf /usr/share/applications/DecentSampler.desktop

    # icons
    sudo rm -rf /usr/share/icons/DecentSampler.png


    # vst
    sudo rm -rf "$VST"/DecentSampler.so
    sudo rm -rf "$VST3"/DecentSampler.vst3
    # bin
    sudo rm -rf "$APPBIN"

    sudo rm -rf /usr/local/bin/DecentSampler

    echo "Done!!!"
}


# Start
echo ""
echo "**************************************"
echo "*       Decent Sampler Installer     *"
echo "**************************************"
echo "Available commands:"
echo ""
echo "  [I]nstall"
echo "  [U]ninstall"
echo "  [Q]uit"
echo ""
echo -n "Command [I,U,Q]:"
read input
echo ""

# 
case "$input" in
    install|INSTALL|I|i)
    aa_install    
    ;;

    uninstall|UNINSTALL|U|u)
    aa_uninstall
    ;;
      
    quit|QUIT|Q|q|exit|EXIT|x|X) 
    echo "Bye!!!"
    ;;
    
    # NOT IMPLEMENTED
    *)
    echo "Choose an available command!!!"
    ;;

esac
