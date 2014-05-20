# Class new_mox::rsync_static_files
#
class new_mox::rsync_static_files($target_host, $target_user='static', $user='rsyncer') {
  user { $user:
    ensure => present,
    home   => "/srv/${user}",
    shell  => '/bin/bash',
  }

  file { "/srv/${user}" :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => User[$user]
  }

  file { "/srv/${user}/.ssh" :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => User[$user]
  }

  file { "/srv/${user}/.ssh/id_rsa" :
    ensure => present,
    source => 'puppet:///modules/new_mox/rsync_keys/static_files',
    owner  => $user,
    group  => $user,
    mode   => 0600,
  }

  file { "/srv/${user}/.ssh/id_rsa.pub" :
    ensure => present,
    source => 'puppet:///modules/new_mox/rsync_keys/static_files.pub',
    owner  => $user,
    group  => $user,
    mode   => 0644,
  }

  file { '/srv/static' :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => User[$user]
  }

  cron { 'sync-static-files':
    command => "rsync -avz -e \"ssh -i /srv/${user}/.ssh/id_rsa\" --exclude=\".*/\" ${target_user}@${target_host}:/srv/${target_user}/files /srv/static",
    user    => $user,
    hour  => '*',
    minute  => 30
  }

}
