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

require_relative 'log'
require_relative 'options'

class Plugins
  @plugin_map = {}

  def self.parse(bot)
    begin
      plugins = YAML.load_file('cfg/plugins.yml')
      plugins = plugins.values.flatten.map(&:to_sym) # convert strings from config to symbols
    rescue => exception
      puts "Unable to open plugins.yml: #{exception}"
      Log.write(Log::CRIT, "Unable to open plugins.yml: #{exception}")
      Log.write(Log::DBUG, exception.backtrace) if Options.debug_mode
      raise if Options.debug_mode
      exit! # unless reloaded
    end

    # Remove duplicate plugins during reload
    unless @plugin_map.empty?
      plugins.each do |plugin|
        if @plugin_map.has_key?(plugin)
          @plugin_map.delete(plugin)
          bot.remove_command(plugin)
        end
      end
    end

    # Initialize each plugin
    bot.clear! # remove any stale events to avoid duplicates
    plugins.each { |plugin_name| @plugin_map[plugin_name] = instance_eval(File.read("plugins/#{plugin_name}.rb")) }
    @plugin_map.each_value { |plugin| plugin.init(bot) }
    # ToDo: Handle exceptions separately for both operations directly above and log appropriately.
    @plugin_map.each_key { |plugin| Log.write(Log::INFO, "#{plugin} loaded.") }

    # Remove obsolete plugins during reloads
    obsolete_plugins = []
    obsolete_plugins = plugins - @plugin_map.keys | @plugin_map.keys - plugins
    unless obsolete_plugins.empty?
      obsolete_plugins.each do |old_plugin|
        @plugin_map.delete(old_plugin)
        bot.remove_command(old_plugin)
        Log.write(Log::INFO, "#{old_plugin} unloaded.")
      end
    end
    obsolete_plugins.size
  end

  class << self
    attr_reader :plugin_map
  end
end
