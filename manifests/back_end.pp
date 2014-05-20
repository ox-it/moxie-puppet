class new_mox::back_end ($user = "moxie", $install_dir = "/srv/moxie/python-env", $processes = '4') {
    include new_mox::base
    include new_mox::moxie
    include new_mox::moxie_supervisor

    $base_dir = "/srv/${user}"

    package { 'uWSGI' :
      ensure => '2.0.3',
      provider => pip,
      require => Package['python-pip', 'python-dev']
    }

    $file_reload_app_server = "${base_dir}/reload-app-server"

    file { $file_reload_app_server :
        ensure => present,
        owner => $user,
        group => $user,
    }

    supervisor::service { "moxie-uwsgi" :
        ensure    => present,
        command   => "/usr/local/bin/uwsgi --master --socket 0.0.0.0:3031 --module moxie.wsgi:app --processes ${processes} -H ${install_dir} --touch-reload ${file_reload_app_server}",
        user      => $user,
        group     => $user,
        stopsignal => 'QUIT',
        environment => "MOXIE_SETTINGS=${base_dir}/app_server_settings.yaml",
    }
}
