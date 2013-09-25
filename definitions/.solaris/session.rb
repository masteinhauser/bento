require File.dirname(__FILE__) + "/../.common/session.rb"

SOLARIS_SESSION = COMMON_SESSION.merge(
  {
    :memory_size=> "768",
    :disk_size => "15360",
    :postinstall_files => [ "update.sh",
                            "vagrant.sh",
                            #"sudoers.sh",
                            #"cleanup.sh",
                            #"minimize.sh"
     ],
    :kickstart_file => ["default.xml", "profile.xml"],
    :sudo_cmd => "echo '%p'|sudo -S bash ./%f",
    :shutdown_cmd => "shutdown -P now"
  }
)
COMMON_SESSION[:virtualbox][:vm_options].merge( :hwvirtex => "on" )
