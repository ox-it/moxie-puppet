class new_mox::moxie ($user = 'moxie', $base_dir = '/srv/moxie') {

  $required_deb_packages = [
      'libxslt1-dev',
      'python-psycopg2',
      'libpq-dev',
      'libgeos-dev',
      'libffi-dev',
      'libssl-dev',
      'python-pip',
      'python-dev',
      'python-virtualenv'
  ]

  package {$required_deb_packages :
    ensure => installed,
  }

  file { "${base_dir}/app_server_settings.yaml" :
    ensure => present,
    source => "puppet:///modules/new_mox/moxie_conf/app_server_settings.yaml",
        owner => $user,
        group => $user,
  }

  file { "${base_dir}/tasks_settings.yaml" :
      ensure => present,
      source => "puppet:///modules/new_mox/moxie_conf/tasks_settings.yaml",
      owner => $user,
      group => $user,
  }

  file { "${base_dir}/celeryconfig.yaml" :
    ensure => present,
    source => "puppet:///modules/new_mox/moxie_conf/celeryconfig.yaml",
        owner => $user,
        group => $user,
  }

  file { "${base_dir}/requirements.txt" :
    ensure => present,
    source => "puppet:///modules/new_mox/moxie_conf/requirements.txt",
  }

}
