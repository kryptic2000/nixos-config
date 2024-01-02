{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base23.nix
      ../../config/users.nix
      ../../config/mail-users.nix
      ../../services/networking23.nix
      ../../services/mysql.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "10.5.1.6/24";
  netcfg.gw4 = "10.5.1.1";

  netcfg.addr4 = "10.5.1.6";
  netcfg.addr6 = "2001:67c:22fc:1001::90";

  networking.enableIPv6 = lib.mkForce false;
  netcfg.ip6 = "2001:67c:22fc:1001::90/64";
  netcfg.gw6 = "2001:67c:22fc:1001::1";

  netcfg.iface = "ens33";
  netcfg.hostName = "db01";
  netcfg.domain = "emtorp.local";
}
