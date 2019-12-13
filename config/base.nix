{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.kernelParams = ["console=ttyS0,115200n8"];
  boot.loader.grub.extraConfig = ''
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking.nameservers = [ "91.228.90.132" ];


  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  security.sudo.wheelNeedsPassword = false;

}

