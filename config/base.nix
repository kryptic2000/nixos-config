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

  environment = {
    systemPackages = with pkgs; [
      #System tools
      git
      wget
    ];
  };


  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking.nameservers = [ "91.228.90.132" ];
  networking = {
    timeServers = [
      "sth1.ntp.se"
      "sth2.ntp.se"
      "ntp3.sptime.se"
      "ntp4.sptime.se"
      ];
    };

  networking.firewall.allowedTCPPorts = [ 22 ];

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Stockholm";

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "03:30";
      options = "--delete-older-than 90d";
    };
    optimise = {
      automatic = true;
      dates = ["04:00"];
    };
  };

  system.stateVersion = "19.09";

}

