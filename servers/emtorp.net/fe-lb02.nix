{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../services/nginx.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

#  environment = {
#    systemPackages = with pkgs; [
#      wireguard
#    ];
#  };


  netcfg.ip4 = "91.228.90.53/29";
  netcfg.gw4 = "91.228.90.49";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:300::20/64";
  netcfg.gw6 = "2001:67c:22fc:300::1";

  netcfg.iface = "ens32";
  netcfg.hostName = "fe-lb02.emtorp.net";

  services.nginx.virtualHosts = let
      base = locations: {
        inherit locations;
        forceSSL = true;
        enableACME = true;
      };
      proxy = port: base {
        "/".proxyPass = "http://192.168.10.2:" + toString(port) + "/";
      };
      www = port: base {
        "/".proxyPass = "http://91.228.90.87:" + toString(port) + "/";
      };
    in {
      # Define example.com as reverse-proxied service on 127.0.0.1:3000
      "stats.emtorp.net" = proxy 3000 // { default = false; };
      "www.emtorp.se" = www 8081 // { default = false; };
      "emtorp.se" = www 8081 // { default = false; };
    };
}

