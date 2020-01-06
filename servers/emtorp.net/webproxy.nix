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

  environment = {
    systemPackages = with pkgs; [
      wireguard
    ];
  };


  netcfg.ip4 = "91.228.90.139/28";
  netcfg.gw4 = "91.228.90.129";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:1::139/64";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.iface = "ens32";
  netcfg.hostName = "webproxy.emtorp.net";

  # Enable Wireguard
  networking.firewall.allowedUDPPorts = [ 12000 ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.10.1/24" ];
      privateKeyFile = "/root/private";
      listenPort = 12000;

      peers = [
        {
          publicKey = "94kR3WxjRXQWYIul1sdFiV/HvhxQqMsUZPf62zFpJng=";
          allowedIPs = [ "192.168.10.0/24" ];
          #allowedIPs = [ "0.0.0.0/0" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };

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

