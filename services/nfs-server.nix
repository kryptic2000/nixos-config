{ config, lib, pkgs, netcfg, ... }:

{

  networking.firewall.allowedTCPPorts = [ 2049 ];

  services.nfs.server = {
    enable = true;
    exports = ''
      /opt/export/maildir     91.228.90.92(rw,async,no_subtree_check) 91.228.90.94(rw,async,no_subtree_check)
    '';
  };
}
