{ config, lib, pkgs, netcfg, ... }:

{
  fileSystems."/mnt/maildir" = {
    device = "10.5.1.5:/opt/export/maildir/";
    fsType = "nfs";
  };
}
