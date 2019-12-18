{ config, lib, ... }:
{
  options.netcfg = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
  config._module.args.netcfg = config.netcfg;
}
