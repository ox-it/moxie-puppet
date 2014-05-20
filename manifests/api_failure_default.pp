class new_mox::api_failure_default {

	$user = 'moxie'

    file { "/srv/${user}/api-not-available.json" :
        ensure  => present,
        group   => $user,
        owner   => $user,
        require => User[$user],
        source  => "puppet:///modules/new_mox/api-not-available.json",
    }
}