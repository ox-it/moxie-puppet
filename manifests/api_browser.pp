class new_mox::api_browser {
    
    $user = 'moxie'
    
    file { "/srv/${user}/hal-browser" :
        ensure => directory,
        recurse => true,
        force => true,
        purge => true,
        source => "puppet:///modules/new_mox/hal-browser",
        owner => $user,
        group => $user,
    }
}