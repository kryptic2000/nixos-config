{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
#      ../../config/emtorp.net/mx_relay.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only


  netcfg.ip4 = "91.228.90.136/28";
  netcfg.gw4 = "91.228.90.129";

  netcfg.addr4 = "91.228.90.136";
  netcfg.addr6 = "2001:67c:22fc:1::136";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:1::136/64";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.iface = "enp0s3";
  netcfg.hostName = "mx1.devkit.se";

}

