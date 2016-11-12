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

require 'options'

# Displays bot help
class Help
  def initialize
    # ToDo: Add command and help text for each loaded plugin dynamically.
  end

  def init(bot)
    bot.command(:help) do |event|
      bot.send_message(event.channel.id, "#{Options.prefix}discofever - Plays some disco music")
      bot.send_message(event.channel.id, "#{Options.prefix}help       - Display commands")
      bot.send_message(event.channel.id, "#{Options.prefix}joinv      - Join voice channel")
      bot.send_message(event.channel.id, "#{Options.prefix}reload     - Reload plugins (restricted)")
      bot.send_message(event.channel.id, "#{Options.prefix}shutdown   - Perform shutdown sequence (restricted)")
      bot.send_message(event.channel.id, "#{Options.prefix}silence    - Stops playing audio")
      bot.send_message(event.channel.id, "#{Options.prefix}uptime     - Report uptime")
    end
  end
end
Help.new
