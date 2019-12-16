{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../config/dns_resolver_unbound.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "dns04.emtorp.net";
  networking.interfaces.enp0s3.ipv4.addresses = [ {
    address = "91.228.90.93";
    prefixLength = 28;
  } ];
  networking.interfaces.enp0s3.ipv6.addresses = [ {
    address = "2001:67c:22fc:100::93";
    prefixLength = 64;
  } ];
  networking.defaultGateway = "91.228.90.81";
  networking.defaultGateway6 = "2001:67c:22fc:100::1";

  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];

}
