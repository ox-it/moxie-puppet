class new_mox::js_front ($hostname, $app_servers) {
  include nginx
  include new_mox::base

  $user = 'moxie'

  # package rubygems not available anymore, seems to be installed by default
  $required_deb_packages = [
    'nodejs',
    'npm',
  ]

  package { 'zurb-foundation' :
      ensure => '4.3.1',
      provider => gem,
  }

  package { 'compass' :
      ensure => '0.12.2',
      provider => gem,
  }

  package { 'modular-scale' :
      ensure => '1.0.6',
      provider => gem,
  }

  $index_filename  = $environment ? {
    production => 'index-prod.html',
    staging    => 'index-prod.html',
    default    => 'index.html',
  }

  package {$required_deb_packages :
    ensure => installed,
  }

  # "npm config set registry http://registry.npmjs.org/" is a hack as we're running into
  # https://stackoverflow.com/questions/12913141/installing-from-npm-fails
  exec { 'npm config set registry http://registry.npmjs.org/ && npm install -g requirejs' :
    require => Package['npm']
  }

  nginx::site { 'new_mox_js_front':
    ensure  => present,
    content => template('new_mox/nginx/js-front.erb'),
  }

  # from Ubuntu 14.04, node is nodejs
  file { '/usr/bin/node':
      ensure => 'link',
      target => '/usr/bin/nodejs',
      require => Package['nodejs']
  }
}
