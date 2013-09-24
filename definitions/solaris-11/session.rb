require File.dirname(__FILE__) + "/../.common/session.rb"

SOLARIS_SESSION = COMMON_SESSION.merge(
  {
    :boot_cmd_sequence => 
      [
        'e',
        '<Down>'*5,
        '<End>',
        '<Backspace>'*22,
        'false',
        '<F10>',
        '<Wait>'*180,
      
        # login as root
        'root<Enter><Wait>',
        'solaris<Enter><Wait>',
      
        # Background check when install is complete, add vagrant to the sudo
        'while (true); do sleep 5; test -f /a/etc/sudoers && grep -v "vagrant" "/a/etc/sudoers" 2> /dev/null',
        ' && echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /a/etc/sudoers && break ; done &<Enter>',
      
        # Background check to see if install has finished and reboot
        '<Enter>while (true); do grep "You may wish to reboot" "/var/svc/log/application-auto-installer:default.log" 2> /dev/null',
        ' && reboot; sleep 10; done &<Enter>',
      
        # Wait for 5 seconds, so the webserver will be up
        'sleep 5; curl http://%IP%:%PORT%/default.xml -o default.xml;',
        'curl http://%IP%:%PORT%/profile.xml -o profile.xml',
        'cp default.xml /system/volatile/ai.xml;',
        'cp profile.xml /system/volatile/profile/enable_sci.xml',
      
        # Start the installer
        'svcadm enable svc:/application/auto-installer:default;',
      
        # Wait for the installer to launch and display the logfile
        'sleep 3; tail -f /var/svc/log/application-auto-installer\:default.log<Enter>'
      ],
    :os_type_id => "Solaris11_64",
    :memory_size=> "768",
    :disk_size => "15360",
    :postinstall_files => [ "update.sh",
                            "vagrant.sh",
                            #"sudoers.sh",
                            #"cleanup.sh",
                            #"minimize.sh"
     ],
    :kickstart_file => "default.xml",
    :sudo_cmd => "echo '%p'|sudo -S bash ./%f",
    :shutdown_cmd => "shutdown -P now" 
  }
)
COMMON_SESSION[:virtualbox][:vm_options].merge( :hwvirtex => "on" )
