 Myclass (host_name){
  include ::icinga2
 
  var $host_name = host_name;
  var i = 0;
  services_list[0] = {mysql};
  
  /*print name host eventually*/
  while (services_list[i]) {
    if defined(Package[$services_list[i]) {
      file {'/etc/icinga2/zones.d/master/hosts.conf':
      ensure => present
      }->
      file_line {'file line in hosts.conf':
      path => '/etc/icinga2/zones.d/master/hosts.conf',
      line => 'vars.server_$services_list[i] == true',
      match => '^vars.server_$services_list[i]*$',
      }
    }
  }
}
