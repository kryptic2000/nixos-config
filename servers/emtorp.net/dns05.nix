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

  networking.hostName = "dns05.emtorp.net";
  networking.interfaces.ens32.ipv4.addresses = [ {
    address = "91.228.90.133";
    prefixLength = 28;
  } ];
  networking.interfaces.ens32.ipv6.addresses = [ {
    address = "2001:67c:22fc:1::133";
    prefixLength = 64;
  } ];
  networking.defaultGateway = "91.228.90.129";
  networking.defaultGateway6 = "2001:67c:22fc:1::1";

  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];

}
