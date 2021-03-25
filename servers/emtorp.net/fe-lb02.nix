{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../services/nginx.nix
      ../../services/varnish.nix
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

  networking.interfaces.ens34.ipv4.addresses = [ {
   address = "10.5.1.2";
    prefixLength = 24;
  } ];

  networking.firewall.extraCommands = "iptables -A INPUT -p vrrp -j ACCEPT";
  services.keepalived.enable = true;
    services.keepalived.vrrpInstances.fe = {
    interface = "ens32";
    state = "MASTER";
    priority = 50;
    virtualIps = [{addr="91.228.90.54";} {addr="2001:67c:22fc:300::f";}];
    virtualRouterId = 230;
  };
  services.nginx.upstreams.varnish.servers."127.0.0.1:6081" = {};
  services.nginx.upstreams.elasticsearch.servers."10.5.1.20:8080" = {};

  services.nginx.virtualHosts."www.devkit.se" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://varnish/";
          extraConfig = ''
            proxy_buffer_size 128k;
            proxy_buffers 4 256k;
            proxy_busy_buffers_size 256k;
          '';
        };
        locations."/_cluster/health/" = {
          proxyPass = "http://elasticsearch/_cluster/health/";
        };
  };
}
