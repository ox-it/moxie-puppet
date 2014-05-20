class new_mox::base {

	user { "moxie" :
		comment => "Distinctively different.",
		home => "/srv/moxie",
		ensure => present,
		shell => "/bin/bash",
	}
	
	file { "/srv/moxie" :
		ensure 	=> directory,
		owner 	=> 'moxie',
		group 	=> 'moxie',
		require => User['moxie']
	}
	
	package { ['git'] :
		ensure => installed,
	}
}
