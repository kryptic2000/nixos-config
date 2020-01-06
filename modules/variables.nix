{ config, lib, ... }:
{
  options.netcfg = {
    ip4 = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    vip4 = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    addr4 = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    gw4 = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    inet6 = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    ip6 = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    vip6 = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    addr6 = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    gw6 = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    iface = lib.mkOption {
      type = lib.types.str;
      default = { };
    };
    ns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["91.228.90.93" "91.228.90.133" "2001:67c:22fc:100::93" "2001:67c:22fc:1::133"];
    };
  };
  config._module.args.netcfg = config.netcfg;
  

}
