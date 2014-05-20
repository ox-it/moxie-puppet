class new_mox::tasks ($user = 'moxie', $install_dir = "/srv/moxie/python-env") {
    include new_mox::base
    include new_mox::moxie
    include new_mox::moxie_supervisor

    $base_dir = "/srv/${user}"
    $python_path = "${install_dir}/bin"

    supervisor::service { "moxie-celery" :
        ensure    => present,
        command   => "${python_path}/python ${python_path}/celery worker --app moxie.worker --concurrency=5",
        user      => $user,
        group     => $user,
        environment => "MOXIE_CELERYCONFIG=${base_dir}/celeryconfig.yaml,MOXIE_SETTINGS=${base_dir}/tasks_settings.yaml",
    }

    supervisor::service { "moxie-celerybeat" :
        ensure    => present,
        command   => "${python_path}/python ${python_path}/celery beat --app moxie.worker --schedule=${base_dir}/celerybeat-schedule --pidfile=${base_dir}/celerybeat.pid",
        user      => $user,
        group     => $user,
        environment => "MOXIE_CELERYCONFIG=${base_dir}/celeryconfig.yaml,MOXIE_SETTINGS=${base_dir}/tasks_settings.yaml",
    }

}
