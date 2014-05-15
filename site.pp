node default {
    # This is where you can declare classes for all nodes.

    if $osfamily =='Windows' {
        Class['install_webpi'] -> Class['install_iis'] -> Class['decode_website']
        include install_webpi, install_iis, decode_website
    }
}

class install_webpi {
    file { "c:/chocolatey.ps1":
        ensure => file,
        source => "puppet:///files/chocolatey.ps1",
        source_permissions => ignore,
    }

    exec { install_chocolatey :
        command  =>'c:\chocolatey.ps1',
        provider => powershell,
        subscribe => File["c:/chocolatey.ps1"],
    }

    package { 'webpi':
        ensure          => installed,
        provider        => 'chocolatey',
        require         => Exec['install_chocolatey'],
    }
}

class install_iis {
    exec { webpi_iis:
        command  =>'& "C:\Program Files\Microsoft\Web Platform Installer\webpicmd.exe" /install /Products:IIS7 /AcceptEULA',
        provider => powershell,
    }
}

class add_website {
    iis::manage_app_pool {'decode_application_pool':
        enable_32_bit           => true,
        managed_runtime_version => 'v4.0',
    }

    iis::manage_site {'decode':
        site_path     => 'C:\inetpub\decode',
        port          => '8080',
        ip_address    => '*',
        #host_header   => 'www.mysite.com',
        app_pool      => 'decode_application_pool'
    }

    iis::manage_virtual_application {'decode_app1':
        site_name   => 'decode',
        site_path   => 'C:\inetpub\decode_app1',
        app_pool    => 'decode_application_pool'
    }
}
