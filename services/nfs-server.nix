{ config, lib, pkgs, netcfg, ... }:

{

  networking.firewall.allowedTCPPorts = [ 2049 ];

  services.nfs.server = {
    enable = true;
    exports = ''
      /opt/export/maildir     91.228.90.90(rw,fsid=0,no_subtree_check) 91.228.90.89(rw,fsid=0,no_subtree_check)
    '';
  };
}
