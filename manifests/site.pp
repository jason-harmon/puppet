class vitylcollectorInstall {

  if $osfamily == 'CentOS' {
    package { 'vityl-collector-linux':
#    owner => 'Administrator',
#    group => 'Users',
#    mode => '0644',
      provider => 'rpm',
      ensure => installed,
      source => 'puppet:///puppet/files/vityl-collector-2.11.0-1.el7.x86_64.rpm',
      install_options => ['--install'],
    }
    
    file { 'linuxguidreplace':
	   # Ensure that the guid file exists on the server, if it does then replace guid on client
       ensure => 'puppet:///puppet/files/guids/' + $host + '.guid.properites', 
	     source => 'puppet:///puppet/files/guids/' + $host + '.guid.properites', 
       path => '/etc/vityl/collector/guid.properties',
	   replace => true,
    }
  }
  
  if $osfamily == 'Windows' {
    package { 'vityl-collector-windows':
      ensure => installed,
      source => 'puppet:///files/vityl-collector-2.11.0.exe',
      install_options => ['/exenoui /qn /l*v install.log'],
    }

    exec { 'start_service' : 
       command => 'sc config vitylcollector start= auto', 
    }
    
    file { 'winguidreplace':
	   # Ensure that the guid file exists on the server, if it does then replace guid on client
       ensure => 'puppet:///files/guids/' + $host + '.guid.properites',
	     source => 'puppet:///files/guids/' + $host + '.guid.properites',
	     path => 'C:/ProgramData/Vityl/Collector/guid.properites',
       replace => true,
    }
  }
}
