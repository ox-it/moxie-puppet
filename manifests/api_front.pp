define new_mox::api_front ($hostname, $app_servers, $user = 'moxie') {
    include nginx
    include new_mox::base
    include new_mox::api_browser
    include new_mox::api_failure_default

	nginx::site { "app_${hostname}":
		ensure  => present,
		content => template("new_mox/nginx/back-end.erb"),
	}
}
