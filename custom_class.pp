# == Class: nexycinga
#
# Full description of class nexycinga here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'nexycinga':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#

class nexycinga {
	$host_fqdn = $::fqdn
	$host_server = $::puppet_server

	notify { "Message from Nexycinga fqdn is: \$host_fqdn ${host_fqdn}": }
	notify { "Message: and your server is: \$host_server ${host_server}": }

	$services_list = ['mysql','http']

	$services_list.each |String $services| {		#.each supported puppet >= v3.8
		if defined(Package[$services]) {
			file {'/etc/icinga2/zones.d/master/hosts.conf':
			ensure => present
			}->
			file_line {'file line in hosts.conf':
			path => '/etc/icinga2/zones.d/master/hosts.conf',
			line => "#${host_fqdn}\n\tvars.server_${services} = true",
			match => "^#${host_fqdn}\n\tvars.server_${services}*$",
			}
		}
		else {
			file {'/etc/icinga2/zones.d/master/hosts.conf':
			ensure => present
			}->
			file_line {'file line in hosts.conf':
			path => '/etc/icinga2/zones.d/master/hosts.conf',
			line => "#${host_fqdn}\n\tvars.server_${services} = false",
			match => "^#${host_fqdn}\n\tvars.server_${services}*$",
	#		line => "#\"$host_name\" vars.server_\"$services\" = false",
	#		match => "^#\"$host_name\" vars.server_\"$services\"*$",
			}
		}
	}
}

##summary description##
/*
*-need to add '#$host_name before 'vars.server_$services_list' for match exactly pattern on the good object host. Tricky time
*/
