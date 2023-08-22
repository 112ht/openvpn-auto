#!/bin/bash

INSTALLER_FILE_PATH="./openvpn-install.sh"


if [ ! -e $INSTALLER_FILE_PATH ]; then
  wget https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
  sudo chmod +x $INSTALLER_FILE_PATH
fi

{

# IP addressの質問に対する応答
    echo "nlb-open-vpn-01-48da5842352903e1.elb.ap-northeast-1.amazonaws.com"
# IPv6 supportの質問に対する応答
    echo "n"
# Port choiceの質問に対する応答
    echo "1"
# Protocolの質問に対する応答
    echo "2"
# DNSの質問に対する応答
    echo "1"
# Enable compressionの質問に対する応答
    echo "n"
# Customize encryption settingsの質問に対する応答
    echo "n"
# Press any key to continueの質問に対する応答
    echo ""
# Client nameの質問に対する応答
    echo "Sample-ABC"
# Client nameの後の質問に対する応答
    echo "1"
} | sudo $INSTALLER_FILE_PATH > inslog.log
