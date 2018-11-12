# DiscoBot - A Discord bot written in Ruby
# Copyright (C) 2016 Lloyd Dilley
# http://www.dilley.me/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Check Ruby version
if RUBY_VERSION < '1.9'
  puts 'DiscoBot requires Ruby >=1.9!'
  exit!
end

#require 'cinch'
require 'discordrb'
require_relative 'log'
require_relative 'options'
require_relative 'plugins'

# Needed so plugins can get at classes in this top-level directory
$LOAD_PATH << Dir.pwd

VERSION = '0.9.0'
puts "DiscoBot #{VERSION}"
Log.write(Log::INFO, "DiscoBot #{VERSION}")
puts 'Parsing options file...'
Log.write(Log::INFO, 'Parsing options file...')
Options.parse
Thread.abort_on_exception = true if Options.debug_mode

# Daemonize or run in foreground if using JRuby
puts 'Going into daemon mode... '
if RUBY_PLATFORM == 'java' && ARGV[0] != '-f'
  puts 'You are using JRuby which does not support fork!'
elsif ARGV[0] != '-f'
  exit if fork
  Process.setsid
  exit if fork
  STDIN.reopen('/dev/null')
  STDOUT.reopen('/dev/null', 'a')
  STDERR.reopen('/dev/null', 'a')
  # Don't chdir to '/' and send output to /dev/null
  Process.daemon(true, false)
  begin
    pid_file = File.open('discobot.pid', 'w')
    pid_file.puts(Process.pid)
    pid_file.close
  rescue => exception
    Log.write(Log::WARN, "Unable to write PID file: #{exception}")
    Log.write(Log::DBUG, exception.backtrace) if Options.debug_mode
    raise if Options.debug_mode
  end
end

discobot = Discordrb::Commands::CommandBot.new(token: Options.token, client_id: Options.client_id, prefix: Options.prefix)

puts 'Loading plugins...'
Log.write(Log::INFO, 'Loading plugins...')
Plugins.parse(discobot)

# 'reload' is a core command and should never be made a plugin
discobot.command(:reload) do |event|
  unless event.user.id == Options.owner_id
    discobot.send_message(event.channel.id, "You are not my master, #{event.user.name}.")
    Log.write(Log::INFO, "#{event.user.name} unsuccessfully attempted to reload plugins.")
    break
  end
  discobot.send_message(event.channel.id, "Reloading plugins, #{event.user.name}...")
  plugins_removed = Plugins.parse(discobot)
  discobot.send_message(event.channel.id, "Plugin reload complete. #{Plugins.plugin_map.size} plugins loaded. #{plugins_removed} plugins unloaded.")
  Log.write(Log::INFO, "#{event.user.name} successfully reloaded plugins.\n#{Plugins.plugin_map.size} plugins loaded.\n#{plugins_removed} plugins unloaded.")
end

#discobot.run
discobot.run :async

# ToDo: Plugin-ize IRC connectivity and read the config
#ircbot = Cinch::Bot.new do
#  configure do |c|
#    c.server = "127.0.0.1"
#    c.nick = "DiscoBot"
#    c.user = "discobot"
#    c.realname = "Discord <-> IRC Bridge"
#    c.channels = ["#test"]
#  end
#  on :message, "hello" do |m|
#    m.reply "Hello, #{m.user.nick}!"
#  end
#end
#ircbot_thread = Thread.new { ircbot.start }
#ircbot_thread.join

# For IRC channel mapping later (only send to text channels)
#primary_server.channels.each do |c|
#  puts c.name
#  puts c.type
#end

discobot.game=(Options.status) unless Options.status.empty?
Log.write(Log::INFO, "Bot status set to: #{Options.status}") unless Options.status.empty?
# Send greeting on connect
key, primary_server = discobot.servers.first
# ToDo: Make startup greeting configurable.
default_channel = primary_server.default_channel.send("It's time to boogie!")
# unless Options.startup_greeting.empty?
Log.write(Log::INFO, "Bot sent startup greeting to channel \"##{primary_server.default_channel.name}\" on server \"#{primary_server.name}\".")

discobot.sync
