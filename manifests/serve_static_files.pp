class new_mox::serve_static_files ($hostname, $static_files_path='/srv/static/files') {
    include nginx

    nginx::site { "static_${hostname}":
      ensure  => present,
      content => template("new_mox/nginx/static-files.erb"),
    }
}
