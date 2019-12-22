{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only


  netcfg.ip4 = "91.228.90.139";
  netcfg.gw4 = "91.228.90.129";

  netcfg.ip6 = "2001:67c:22fc:1::139";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.iface = "ens32";
  netcfg.hostName = "webproxy.emtorp.net";

  # Enable Wireguard
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.10.1/24" ];
      privateKeyFile = "/root/private";
      listenPort = 12000;

      peers = [
        {
          publicKey = "94kR3WxjRXQWYIul1sdFiV/HvhxQqMsUZPf62zFpJng=";
          allowedIPs = [ "192.168.10.0/24" ];
          #allowedIPs = [ "0.0.0.0/0" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

