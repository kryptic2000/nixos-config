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
  services.nginx.upstreams.magento.servers."10.5.1.21" = {};
  services.nginx.upstreams.magento.servers."10.5.1.11" = {};
  services.nginx.upstreams.magento.extraConfig = ''
    ip_hash;
  '';

  services.nginx.virtualHosts."devkit.se" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://magento";
      };
  };
  services.nginx.virtualHosts."www.devkit.se" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://magento";
      };
  };
}
