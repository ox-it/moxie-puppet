# Class new_mox::static_files
#
class new_mox::static_files($authorised_host, $user='static') {
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

  # Read write access on group moxie
  file { "/srv/${user}/files" :
    ensure  => directory,
    owner   => $user,
    group   => 'moxie',
    mode    => '0775',
    require => [User[$user], User['moxie']]
  }

  file { "/srv/${user}/.ssh" :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => [User[$user], File["/srv/${user}"]]
  }

  file { "/srv/${user}/.ssh/authorized_keys" :
    ensure  => present,
    content => template("new_mox/static-files-rsync-authorized-keys.erb"),
    owner   => $user,
    group   => $user,
    require => File["/srv/${user}/.ssh"]
  }

}
