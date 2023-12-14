{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base23.nix
      ../../config/users.nix
      ../../services/networking23.nix
      ../../config/emtorp.net/smtp.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.89/28";
  netcfg.gw4 = "91.228.90.81";

  netcfg.addr4 = "91.228.90.89";
  netcfg.addr6 = "2001:67c:22fc:100::89";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:100::89/64";
  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.iface = "ens33";
  netcfg.hostName = "smtp01";
  netcfg.domain = "emtorp.se";
}

