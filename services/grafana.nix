{ config, lib, pkgs, netcfg, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3000 ];
  services.grafana = {
	addr = ""; # listen (bind) to all network interfaces (i.e. 127.0.0.1, and ipAddress)
	enable = true;
	port = 3000;
	domain = "localhost";
	protocol = "http";
	dataDir = "/var/lib/grafana";
  };
  systemd.services.grafana = {
	# wait until all network interfaces initialize before starting Grafana
	after = [ "network-interfaces.target" ];
	wants = [ "network-interfaces.target" ];
  };  
#  services.grafana.provision = {
#	enable = true;
#	datasources = map mkGrafanaInfluxSource
#	  ["my-influx-database-name" "database-name-2"];
#  };
}
