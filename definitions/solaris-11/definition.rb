require File.dirname(__FILE__) + "/../.solaris/session.rb"

iso = "sol-11_1-ai-x86.iso"

session = SOLARIS_SESSION.merge(
  :iso_file => iso,
  :iso_md5 => "f697fe5bc9cc4c901a52ce43229ab0d6",
  :iso_src => "",
  :iso_download_timeout => 1000,
  :iso_download_instructions => "- You need to download the AI (automated installer) iso manually (not the text one!)\n" +
    "http://www.oracle.com/technetwork/server-storage/solaris11/downloads/index.html\n\n" +
    "- The version tested is 11.1\n"+
    "- For other version: changed the iso filename+checksum\n",
  :boot_cmd_sequence =>
    [
      'e',
      '<Down>'*5,
      '<End>',
      '<Backspace>'*22,
      'false',
      '<F10>',
      '<Wait>'*120,

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
      'curl http://%IP%:%PORT%/profile.xml -o profile.xml;',
      'cp default.xml /system/volatile/ai.xml;',
      'mkdir /system/volatile/profiles;',
      'cp profile.xml /system/volatile/profiles/profile.xml;',

      # Start the installer
      'svcadm enable svc:/application/auto-installer:default;',

      # Wait for the installer to launch and display the logfile
      'sleep 3; tail -f /var/svc/log/application-auto-installer\:default.log<Enter>'
    ],
  :os_type_id => "Solaris11_64",
)

Veewee::Session.declare session
