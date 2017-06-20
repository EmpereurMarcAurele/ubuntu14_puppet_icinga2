import "nodes.pp"

$puppetserver="nc0030.int.nexylan.net"

filebucket {"main":
	server	=> puppet,
	path	=> false,
}

File { backup	=> main }
