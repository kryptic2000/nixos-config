# nixos-config
cd /etc/nixos/

sudo ln -sr /etc/nixos/nixos-config/servers/[DOMAIN]/[HOST].nix configuration.nix


----


#!/run/current-system/sw/bin/bash
echo "Enter system hostname:"
read hostname
rm -rf /etc/nixos/nixos-config/
cd /etc/nixos/
git clone https://github.com/kryptic2000/nixos-config.git
$SHELL /etc/nixos/nixos-config/install.sh $hostname

