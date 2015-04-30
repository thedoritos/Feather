#!/bin/sh

# decode profiles
openssl aes-256-cbc -k $DECORD_CERTS -in travis/profiles/FezaarAdHoc.mobileprovision.enc -d -a -out travis/profiles/FezaarAdHoc.mobileprovision
openssl aes-256-cbc -k $DECORD_CERTS -in travis/certs/AppleWorldwideDeveloperRelationsCertificationAuthority.cer.enc -d -a -out travis/certs/AppleWorldwideDeveloperRelationsCertificationAuthority.cer
openssl aes-256-cbc -k $DECORD_CERTS -in travis/certs/Certificates.cer.enc -d -a -out travis/certs/Certificates.cer
openssl aes-256-cbc -k $DECORD_CERTS -in travis/certs/Certificates.p12.enc -d -a -out travis/certs/Certificates.p12

# create keychain on VM
# see http://docs.travis-ci.com/user/common-build-problems/#Mac%3A-Code-Signing-Errors
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

# add profile to keychain
security import ./travis/certs/AppleWorldwideDeveloperRelationsCertificationAuthority.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./travis/certs/Certificates.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./travis/certs/Certificates.p12 -k ~/Library/Keychains/ios-build.keychain -P $CERTS_PASS -T /usr/bin/codesign

# save profile
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "./travis/profiles/FezaarAdHoc.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
