class mywebsite {
  include mywebsite::params

  $context = $mywebsite::params::context

  iis::manage_app_pool {'IAFOD_POOL':
    ensure		    => present,
    enable_32_bit           => true,
    managed_runtime_version => 'v4.0',
    require		    => File['dos_directory'],
  } ->

  iis::manage_site {'IAFOD':
    site_path     => 'C:\Program Files\DOS\IAFOD',
    site_id       => '11',
    port          => '8100',
    ip_address    => '*',
    app_pool      => 'IAFOD_POOL'
  }
  
  file { 'dos_directory' :
    name 	  => 'C:\Program Files\DOS',
    ensure 	  => present,
    source 	  => "puppet:///modules/mywebsite/DOS",
    recurse	  => true,
  }

  file { 'iafod_file' :
    name 	  => 'C:\Program Files\DOS\IAFOD\index.html',
    ensure        => present,
    content       => template('mywebsite/index.html.erb'),
    require       => File['dos_directory'],
  }
    
}
