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

  networking.hostName = "mx01.emtorp.net";
  networking.interfaces.enp0s3.ipv4.addresses = [ {
    address = "91.228.90.88";
    prefixLength = 28;
  } ];
  networking.interfaces.enp0s3.ipv6.addresses = [ {
    address = "2001:67c:22fc:100::88";
    prefixLength = 64;
  } ];

  networking.defaultGateway = "91.228.90.81";
  networking.defaultGateway6 = "2001:67c:22fc:100::1";
}

