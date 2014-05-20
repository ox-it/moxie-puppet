class new_mox::postgresql ($user = moxie) {
    class { 'postgresql::server' :
        listen_addresses => '*',
    }

    $deb = 'postgresql-server-dev-9.3'
    
    package { $deb :
        ensure => installed
    }
    
    postgresql::server::db { $user :
        user     => $user,
        password => $user,
        require => Package[$deb]
    }

    postgresql::server::pg_hba_rule { 'allow application network to access moxie database':
      description => "Open up postgresql for access from 192.168.2.1/24",
      type => 'host',
      database => $user,
      user => $user,
      address => '192.168.2.1/24',
      auth_method => 'md5',
    }
}
