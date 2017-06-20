node base {
	include	apache
	include	icinga2
}

node server {
	include	icinga2
	
	class {'::icinga2::feature::command':
                ensure          =>      'present',
        }
	class {'::icinga2::feature::api':
		ensure		=> 'present',
#		pki		=> 'icinga2',
#		ca_host		=> 'nc0030.int.nexylan.net',
		accept_commands => true,
		endpoints       => {
			'nc0030.int.nexylan.net'        => {},
			'nc0031.int.nexylan.net'        => {
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
			'nc0031.int.nexylan.net'=> {
				'endpoints'     => ['nc0031.int.nexylan.net'],
				'parent'        => 'master',
			},
			'nc0032.int.nexylan.net'=> {
				'endpoints'     => ['nc0032.int.nexylan.net'],
				'parent'        => 'master',
			},
		}
	}
	icinga2::object::zone {'global-templates':
		global  => true,
	}
        class { '::icinga2::feature::idomysql':
		ensure		=> 'present',
                user          => 'icinga2',
                password      => 'supersecret',
                database      => 'icinga2',
                import_schema => true,
                require       => Mysql::Db['icinga2'],
        }
}

node 'nc0030.int.nexylan.net' inherits server {
	
	include	mysql::server
	mysql::db { 'icinga2':
		user     => 'icinga2',
		password => 'supersecret',
		host     => 'localhost',
		grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
	}
}

node 'nc0031.nexylan.net' inherits base {

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
