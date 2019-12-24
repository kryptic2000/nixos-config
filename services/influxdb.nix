{ config, lib, pkgs, netcfg, ... }:

{
  services.influxdb = {
    enable = true;
  };
}
