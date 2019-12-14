{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../config/dns_resolver.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "dns05.emtorp.net";
  networking.interfaces.enp0s3.ipv4.addresses = [ {
    address = "91.228.90.132";
    prefixLength = 28;
  } ];
  networking.defaultGateway = "91.228.90.129";
}

