class new_mox::moxie_supervisor ($user = 'moxie', $group = 'moxie') {

  class { 'supervisor' :
    unix_http_server_chown => "${user}:${group}",
  }

}
