{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../config/dns_resolver.nix
      #../../config/emtorp.net/mx_relay.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "dns04.emtorp.net";
  networking.interfaces.enp0s3.ipv4.addresses = [ {
    address = "91.228.90.93";
    prefixLength = 28;
  } ];
  networking.defaultGateway = "91.228.90.81";
}

