# ubuntu14_puppet_icinga2
automatic install of puppet & amp / icinga 2 on ubuntu 14.04             
automatic add/remove services of icinga2 / nagios-plugins

There are 3 way to collect data on icinga2.
Here we use the "Top-down" models, witch necessit a conf only on server side.

/*********/
puppet - amp - icinga2
/*********/                 
-The file "master_config_icinga" provide an automatic connection between the server and the client: certificate are automaticly signed.        
-The file "init_server.pp" is an early try to make a custom puppet module for an automatics installation of: puppet, amp and modules from puppet.                 
-The files "nodes.pp" and "site.pp" are deprecated, don't use it.

/*********/
services icinga2 / nagios-plugin #### WORK IN PROGRESS
/*********/              
-The file "custom_class.pp" the main class to add/remove services to monitor, depends witch services was already installed on your remote host.
On puppet agent execution, this class was executed on the remote host.
                      

/***sources***/
http://hadooppowered.com/2014/05/12/setup-a-puppetmaster-with-puppetdb-and-puppetboard/
