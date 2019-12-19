{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../config/emtorp.net/mx_relay.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only


  netcfg.ip4 = "91.228.90.134";
  netcfg.gw4 = "91.228.90.129";

  netcfg.ip6 = "2001:67c:22fc:1::134";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.iface = "ens32";
  netcfg.hostName = "mx02.emtorp.net";

  netcfg.dns = [ "91.228.90.132" ];
}

