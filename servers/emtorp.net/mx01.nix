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
  networking.defaultGateway = "91.228.90.81";

  system.stateVersion = "19.09"; # Did you read the comment?

}

