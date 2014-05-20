class new_mox::jetty($version = '9.1.5.v20140505', $jetty_user = 'jetty', $jetty_dir = '/srv/jetty', $syslog = '', $local_log_dir = '/var/log/jetty') {

    $source_url = "http://download.eclipse.org/jetty/${version}/dist/jetty-distribution-${version}.tar.gz"
	$package = "jetty-distribution-${version}"
	$destination = "$jetty_dir/$package.tar.gz"
    $jetty_home = "$jetty_dir/$package"
    $jetty_default_home = "$jetty_dir/server"

	file { $jetty_dir :
		ensure 	=> directory,
		owner 	=> $jetty_user,
		group 	=> $jetty_user,
	}

	exec { "download-jetty" :
		command => "curl -o $destination $source_url",
		unless 	=> "test -f $destination",
		user 	=> $jetty_user,
		require => [Package["curl"], User[$jetty_user], File[$jetty_dir]],
	}

	exec { "unpack-jetty" :
		command => "tar -xzf $destination --directory=$jetty_dir",
		unless 	=> "test -d $jetty_home",
		user 	=> $jetty_user,
		require => [Exec["download-jetty"]],
	}

	$deb_packages = [
		"curl",
		"openjdk-7-jre-headless",
	]

	package { $deb_packages :
		ensure => present,
	}

	# Jetty

	file { "/etc/default/jetty" :
		ensure 	=> present,
		source 	=> "puppet:///modules/new_mox/jetty-default",
		owner 	=> root,
		group 	=> root,
	}

	file { $jetty_home :
		ensure => present,
		recurse => true,
		owner => $jetty_user,
		group => $jetty_user,
		source => "puppet:///modules/new_mox/jetty_conf/etc",
		require => [File[$jetty_dir], Exec['unpack-jetty']]
	}

    file { $jetty_default_home :
        ensure => link,
        target => $jetty_home,
        owner => $jetty_user,
        group => $jetty_user,
        require => [File[$jetty_home], File[$jetty_dir]],
    }

    file { "$jetty_default_home/resources" :
	    ensure => directory,
        purge => true,
        force => true,
	    recurse => true,
		owner => $jetty_user,
		group => $jetty_user,
		require => [File[$jetty_dir], Exec['unpack-jetty']]
    }

    file { "$jetty_default_home/resources/logback.xml" :
	    ensure => present,
		owner => $jetty_user,
		group => $jetty_user,
        content => template("new_mox/jetty/logback.erb"),
		require => File["$jetty_default_home/resources"]
    }

    file { "$jetty_default_home/webapps.demo" :
        ensure => absent,
        force => true,
        require => File[$jetty_default_home]
    }

    file {"/etc/init.d/jetty" :
        ensure => present,
        source => "$jetty_default_home/bin/jetty.sh",
        owner => root,
        group => root,
        require => File[$jetty_default_home],
        notify => Exec['jetty-on-start'],
    }

    # make sure jetty starts automatically
    exec { "jetty-on-start" :
        command => "update-rc.d jetty defaults",
        unless => "test -f /etc/rc0.d/K20jetty",
        user => root,
    }
}
