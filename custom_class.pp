 Myclass (host_name){
  include ::icinga2
 
  $host_name = host_name
  $services_list = ["mysql","php",]
  
  /*print name host eventually*/
  $services_list.each |$services_list| {
    if defined(Package[$services_list) {
      file {'/etc/icinga2/zones.d/master/hosts.conf':
      ensure => present
      }->
      file_line {'file line in hosts.conf':
      path => '/etc/icinga2/zones.d/master/hosts.conf',
      line => '#$host_name vars.server_$services_list == true',
      match => '^#$host_name vars.server_$services_list*$',
      }
    }
    else {
    file {'/etc/icinga2/zones.d/master/hosts.conf':
      ensure => present
      }->
      file_line {'file line in hosts.conf':
      path => '/etc/icinga2/zones.d/master/hosts.conf',
      line => '#$host_name vars.server_$services_list == false',
      match => '^#$host vars.server_$services_list*$',
      }
    }
  }
}
##summary description##
/*
*-need to add '#$host_name before 'vars.server_$services_list' for match exactly pattern on the good object host.
*/
