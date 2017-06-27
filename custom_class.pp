 Myclass (host_name){
  include ::icinga2
 
  $host_name = host_name
  $i = 0
  $services_list['mysql']
  
  /*print name host eventually*/
  while ($services_list[$i]) {
    if defined(Package[$services_list[i]) {
      file {'/etc/icinga2/zones.d/master/hosts.conf':
      ensure => present
      }->
      file_line {'file line in hosts.conf':
      path => '/etc/icinga2/zones.d/master/hosts.conf',
      line => 'vars.server_$services_list[$i] == true',
      match => '^vars.server_$services_list[$i]*$',
      }
    }
    else {
    file {'/etc/icinga2/zones.d/master/hosts.conf':
      ensure => present
      }->
      file_line {'file line in hosts.conf':
      path => '/etc/icinga2/zones.d/master/hosts.conf',
      line => 'vars.server_$services_list[$i] == false',
      match => '^vars.server_$services_list[$i]*$',
      }
    }
    $i++;
  }
}
