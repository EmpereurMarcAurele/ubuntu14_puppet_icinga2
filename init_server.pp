class	lamp_server {
##core package stdlib, concat & apt; this modules are required
	exec {'stdlib':
                command => 'puppet module install puppetlabs-stdlib',
                path => ['/usr/bin', '/bin'],} 
	exec {'concat':
		command => 'puppet module install puppetlabs-concat',
		path => ['/usr/bin', '/bin'],}
	exec {'apt': 
                command => 'puppet module install puppetlabs-apt', 
                path => ['/usr/bin', '/bin'],}
##chocolatey required for Windows
#	exec {'chocolatey':
#                command => 'puppet module install puppetlabs-chocolatey', 
#                path => ['/usr/bin', '/bin'],}
##zypprepo required for SLES & OpenSUSE
#	exec {'zypprepo':
#                command => 'puppet module install puppet-zypprepo',
#                path => ['/usr/bin', '/bin'],}
##package apache2, mysql, php7
	exec {'apache2':
		command => 'puppet module install puppetlabs-apache',
		path => ['/usr/bin', '/bin'],}
	exec {'mysql':
		command => 'puppet module install puppetlabs-mysql',
		path => ['/usr/bin', '/bin'],}
	##php & icinga2 need some special attention
	exec {'add_repo_php':
		command => 'add-apt-repository ppa:ondrej/php',
		path => ['/usr/bin', '/bin'],}
	exec {'add_repo_icinga2':
		command => 'add-apt-repository ppa:formorer/icinga',
		path => ['/usr/bin', '/bin'],}
#simple update
        exec {'update':
		command => 'apt-get update',
		path => ['/usr/bin', '/bin'],}
	exec {'php':
		command => 'puppet module install mayflower-php',
		path => ['/usr/bin', '/bin'],}
##package icinga2 & icingaweb2
}

class {'stdlib':}

class {'apt':}

class {'apache':}

class {'::mysql::server':
	root_password => 'needroot'}

class {'::php':
	ensure => latest,
	manage_repos => true,
	fpm => true,
	dev => true,
	composer => true,
	pear => true,}

include ::icinga2
include ::mysql::server

mysql::db { 'icinga2':
  user     => 'icinga2',
  password => 'supersecret',
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
}

class{ '::icinga2::feature::idomysql':
  user          => 'icinga2',
  password      => 'supersecret',
  database      => 'icinga2',
  import_schema => true,
  require       => Mysql::Db['icinga2'],
}
