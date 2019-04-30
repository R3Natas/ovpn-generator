#!/bin/bash
# Simple script created for automated OpenVPN profiles generation
# This script creates user certificates and generates .ovpn profile later on
# (c) R3Natas, 2019

read -p "Please type user name you want to generate certificate for: " user

[ -z $user ] && { echo "User field cannot be empty!"; exit 1; }

[ -f keys/$user.crt ] && { echo "Certificate for user $user already exists"; exit 2; }

source ./vars

./build-key $user


# The Default.txt file is a template configuration file used to generate profiles. The only missing part is cerfiticates and keys.
(
cat Default.txt

echo '<ca>'
cat keys/ca.crt
echo '</ca>'

echo '<cert>'
tail --lines=+66 keys/$user.crt
echo '</cert>'

echo '<key>'
cat keys/$user.key
echo '</key>'

echo '<tls-auth>'
cat keys/ta.key
echo '</tls-auth>'
) > keys/ovpns/$user.ovpn
