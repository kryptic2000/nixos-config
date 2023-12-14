{ config, lib, pkgs, netcfg, ... }:

{
  imports = [
      ../modules/variables23.nix
  ];
  boot.loader.grub.enable = true;

  boot.kernelParams = ["console=ttyS0,115200n8"];
  boot.loader.grub.extraConfig = ''
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  environment.systemPackages = [
      #System tools
      pkgs.git
      pkgs.wget
      pkgs.inetutils
      pkgs.tcpdump
      pkgs.openssl
    ];


  networking.useDHCP = false;
  networking.firewall.enable = true;
  networking = {
    timeServers = [
      "sth1.ntp.se"
      "sth2.ntp.se"
      "ntp3.sptime.se"
      "ntp4.sptime.se"
      ];
    };

  networking.firewall.extraCommands = ''
        iptables -A nixos-fw -p tcp -m state --state NEW --source 91.228.90.0/24 --destination ${netcfg.ip4} --dport 22 -j ACCEPT
        '';

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
      extraConfig = "MaxAuthTries 1";
      openFirewall = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Stockholm";

  nix = {
    settings = {
      auto-optimise-store = true;
    };
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

