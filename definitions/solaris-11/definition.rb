require File.dirname(__FILE__) + "/../.solaris/session.rb"

iso = "sol-11_1-ai-x86.iso"

session =
  SOLARIS_SESSION.merge( :iso_file => iso,
                        :iso_md5 => "f697fe5bc9cc4c901a52ce43229ab0d6",
                        :iso_src => "",
                        :iso_download_timeout => 1000,
                        :iso_download_instructions => "- You need to download the AI (automated installer) iso manually (not the text one!)\n" +
                          "http://www.oracle.com/technetwork/server-storage/solaris11/downloads/index.html\n" +
                          "\n"+
                          "- The version tested is 11.1\n"+
                          "- For other version: changed the iso filename+checksum\n",
                       )

Veewee::Session.declare session
