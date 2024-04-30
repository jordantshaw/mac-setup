#!/usr/bin/env bash

set -e 

CERT_FILE=${1:-bundled-cert.pem}

security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > $CERT_FILE
security find-certificate -a -p /Library/Keychains/System.keychain >> $CERT_FILE
security find-certificate -a -p ~/Library/Keychains/login.keychain-db >> $CERT_FILE

