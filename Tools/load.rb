#!/usr/bin/env ruby -wU

#################################################################
# build Soundflower, install it, and start it
# installs to /Library/Extensions
# requires admin permissions and will ask for your password
#################################################################

#################################################################
#       IMPORTANT!!!!!!!!!!!!!!!!!
# Mac OSX 10.10 (Yosemite) disabled kext installation even if
# signed with Mac Developer Program. In order to still be able
# to install the kernel extension, we need to run the following
# command and restart:
#       sudo nvram boot-args="kext-dev-mode=1"
#       Restart and now unsigned kexts can be installed!!
#################################################################

#require 'open3'
require 'fileutils'
require 'pathname'
#require 'rexml/document'
#include REXML

# This finds our current directory, to generate an absolute path for the require
libdir = "."
Dir.chdir libdir        # change to libdir so that requires work

@svn_root = ".."

puts "  Unloading and removing existing Soundflower.kext"
if File.exists?("/Library/Extensions/Soundflower.kext")
    puts "    first unload (will often fail, but will cause Soundflower's performAudioEngineStop to be called)"
    `sudo kextunload /Library/Extensions/Soundflower.kext`
    puts "    second unload (this one should work)"
    `sudo kextunload /Library/Extensions/Soundflower.kext`
    puts "    removing"
    puts `sudo rm -rf /Library/Extensions/Soundflower.kext`
end

if (ARGV[0]!="unload" && ARGV[0]!="-unload" && ARGV[0]!="u" && ARGV[0]!="-u")
    puts "  Copying to /Library/Extensions and loading kext"
    `sudo cp -rv "#{@svn_root}/Build/InstallerRoot/Library/Extensions/Soundflower.kext" /Library/Extensions`
    `sudo kextload -tv /Library/Extensions/Soundflower.kext`
    `sudo touch /Library/Extensions`
end

puts "  Done."
puts ""
exit 0
