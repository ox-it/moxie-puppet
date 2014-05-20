class new_mox::solr ($version = '4.7.2', $syslog = '') {

	$jetty_home = "/srv/jetty"
    $jetty_server = "$jetty_home/server"
	$solr_user = 'jetty'

	user { $solr_user :
		comment => "Solr",
		home => $jetty_home,
		ensure => present,
		shell => "/bin/bash",
	}

    class { 'new_mox::jetty' :
        syslog => $syslog
    }

	# Solr

	$package = "solr-${version}"

	$source_url = "http://mirror.ox.ac.uk/sites/rsync.apache.org/lucene/solr/${version}/${package}.tgz"
	$install_dir = '/srv/solr'
	$destination = "$install_dir/$package.tgz"


	file { $install_dir :
		ensure 	=> directory,
		owner 	=> $solr_user,
		group 	=> $solr_user,
	}

	file { '/var/log/jetty' :
		ensure 	=> directory,
		owner 	=> $solr_user,
		group 	=> $solr_user,
	}

    # logging
    file { "${jetty_server}/lib/ext" :
        ensure => directory,
        recurse => true,
        owner => $solr_user,
        group => $solr_user,
		source => "puppet:///modules/new_mox/jetty_logging",
		require => [Exec['unpack-jetty'], Exec['unpack-solr']]
    }

	exec { "download-solr" :
		command => "curl -f -o $destination $source_url",
		unless 	=> "test -f $destination",
		user 	=> $solr_user,
		require => [Package["curl"], User[$solr_user], File[$install_dir]],
	}

	exec { "unpack-solr" :
		command => "tar -xzf $destination --directory=$install_dir",
		unless 	=> "test -d $install_dir/$package",
		user 	=> $solr_user,
		require => [Exec["download-solr"], File['/var/log/jetty']],
	}

	file { "$install_dir/apache-solr" :
		ensure 	=> "link",
		target 	=> "$install_dir/$package",
		owner 	=> $solr_user,
		group 	=> $solr_user,
		require => Exec['unpack-solr'],
	}

	file { "$install_dir/moxie" :
		ensure => directory,
		recurse => true,
		owner => $solr_user,
		group => $solr_user,
		source => "puppet:///modules/new_mox/solr_conf",
	}

    # context: /solr --> solr-VERSION.war
	file { "$jetty_server/webapps/solr.xml" :
		ensure 	=> present,
		owner 	=> $jetty_user,
		group 	=> $jetty_user,
        content => template("new_mox/jetty/solr-context.erb"),
		require => Exec['unpack-jetty'],
	}
}
