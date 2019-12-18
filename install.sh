#!/bin/sh
usage() {
 echo "Usage: $0 <hostname>"
 exit 1
}

if [ $# -ne 1 ] ; then
    usage
else
    cd /etc/nixos/
    rm configuration.nix
    pat='^([A-Za-z0-9]+)\.(.*)'
    [[ "$1" =~ $pat ]]
    echo HOST="${BASH_REMATCH[1]}"
    echo DOMAIN="${BASH_REMATCH[2]}"
    n -sr /etc/nixos/nixos-config/servers/${BASH_REMATCH[2]}/${BASH_REMATCH[1]}.nix configuration.nix
    nixos-rebuild switch --upgrade
fi
