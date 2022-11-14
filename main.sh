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

############################################################
# Constants                                                #
############################################################
TEMPDIR=$(readlink -f "@temp")
VST=$(readlink -f "/usr/lib/vst")
VST3=$(readlink -f "/usr/lib/vst3")
APPBIN=$(readlink -f "/opt/DecentSampler")
COMMAND_NAME="./main.sh"

############################################################
# Install Required                                         #
############################################################
CheckRequired () {
    
    # test for required commands
    command -v unzip >/dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Aborting."; exit 1; }

    # installing required libcurl-gnutls
    # echo "Installing required libcurl-gnutls package..."
    # sudo pacman -S libcurl-gnutls
}

############################################################
# Install                                                  #
############################################################
Install () {
    echo ""
    echo "Installing DS Sampler..."

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
    echo ""
}


############################################################
# Uninstall                                                #
############################################################
Uninstall () {

    echo ""
    echo "Unistalling DS Sampler..."

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
    echo ""
}


############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo
   echo "Usage: $COMMAND_NAME [OPTIONS]"
   echo
   echo "Install Decent Sampler for Linux."
   echo
   echo "Options:"
   echo "  -h     Print this Help."
   echo "  -i     Install DS Sampler."
   echo "  -u     Uninstall DS Sample."
   echo
}

############################################################
# InvalidOption                                            #
############################################################
InvalidOption()
{
   # Display Invalid Option Text
   echo
   echo "$COMMAND_NAME: invalid option."
   echo "See '$COMMAND_NAME -h'"
   echo
}

############################################################
# Main Program                                             #
############################################################

# No option supplied
if [ $# -eq 0 ]
    then
        Help
        exit;
fi


############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hiu" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      i) # Install DS Sample
         CheckRequired
         Install
         exit;;
      u) # Uninstall DS Sampler
         Uninstall
         exit;;
      \?) # Invalid option
         InvalidOption
         exit;;
   esac
done
