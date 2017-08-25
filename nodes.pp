class nexycin {
			file {'/etc/icinga2/zones.d/README':
			path => '/etc/icinga2/zones.d/README',
			ensure => present,
			}
	$host_fqdn = $::fqdn
	$host_server = $::puppet_server

	notify { "Message from Nexyci fqdn is:  ${host_fqdn}": }
	notify { "And your server is:  ${host_server}": }
}

node 'nc0032.int.nexylan.net' {
	include nexycin
	include icinga2

        class {'::icinga2::feature::api':
                ensure          => 'present',
                pki             => 'icinga2',
                ca_host         => 'nc0030.int.nexylan.net',
	#Salt Dont change anything for the moment.
		ticket_salt     => '5a3d695b8aef8f18452fc494593056a4',
                accept_config   =>      true,
                accept_commands =>      true,
                endpoints       => {
                        'NodeName'              => {},
                        'nc0030.int.nexylan.net'=> {
                                'host'  => 'nc0030.int.nexylan.net',
                        },
                },
                zones           => {
                        'master'        => {
                                'endpoints'     => ['nc0030.int.nexylan.net'],
                        },
                        'ZoneName'      => {
                                'endpoints'     => ['NodeName'],
                                'parent'        => 'master',
                        },
                }
        }
        icinga2::object::zone {'global-templates':
                global => true,
        }
}


node 'nc0031.nexylan.net' {
	include nexycin
        include haproxy
        include icinga2

	class {'::icinga2::feature::api':
		ensure          => 'present',
		pki             => 'icinga2',
		ca_host         => 'nc0030.int.nexylan.net',
		accept_config	=>	true,
		accept_commands =>	true,
		endpoints       => {
			'NodeName'              => {},
			'nc0030.int.nexylan.net'=> {
				'host'  => 'nc0030.int.nexylan.net',
			},
		},
		zones           => {
			'master'        => {
				'endpoints'     => ['nc0030.int.nexylan.net'],
			},
			'ZoneName'      => {
				'endpoints'     => ['NodeName'],
				'parent'        => 'master',
			},
		}
	}
	icinga2::object::zone {'global-templates':
		global => true,
	}
}

node 'nc0030.int.nexylan.net' {
	include nexycinga
	include ::mysql::server
	
	class {'::icinga2':
		confd     => true,
		features  => ['perfdata', 'checker','syslog', 'mainlog','notification','statusdata','compatlog','command', 'debuglog'],
		constants => {
			'NodeName' => 'nc0030.int.nexylan.net',
			'ZoneName' => 'master',
			'TicketSalt' => '5a3d695b8aef8f18452fc494593056a4',
		},
	}

	class {'::icinga2::feature::api':
               ensure          => 'present',
               pki             => 'icinga2',
               ca_host         => 'nc0030.int.nexylan.net',
               accept_commands => true,
               endpoints       => {
                       'nc0030.int.nexylan.net'        => {},
                       'nc0031.nexylan.net'        => {
                               'host'  => '10.10.5.31'
                       },
                       'nc0032.int.nexylan.net'        => {
                               'host'  => '10.10.5.32'
                       }
               },
               zones           => {
                       'master'        => {
                               'endpoints'     => ['nc0030.int.nexylan.net'],
                       },
                       'nc0031.nexylan.net'=> {
                               'endpoints'     => ['nc0031.nexylan.net'],
                               'parent'        => 'master',
                       },
                       'nc0032.int.nexylan.net'=> {
                               'endpoints'     => ['nc0032.int.nexylan.net'],
                               'parent'        => 'master',
                       },
               }
       }

	mysql::db { 'icinga2':
		user     => 'icinga2',
		password => 'supersecret',
		host     => 'localhost',
		grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
	}

	class { '::icinga2::feature::idomysql':
		ensure          => 'present',
                user          => 'icinga2',
                password      => 'supersecret',
                database      => 'icinga2',
                import_schema => true,
                require       => Mysql::Db['icinga2'],
        }

	icinga2::object::zone {'global-templates':
		global => true,
	}
}
