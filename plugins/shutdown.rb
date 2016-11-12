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

# Shuts down the bot
class Shutdown
  def initialize
    #
  end

  def init(bot)
    bot.command(:shutdown, help_available: false) do |event|
      unless event.user.id == Options.owner_id
        bot.send_message(event.channel.id, "You are not my master, #{event.user.name}.")
        break
      end
      bot.send_message(event.channel.id, "Disco is dead because of you, #{event.user.name}. :(")
      bot.stop
      exit
    end
  end
end
Shutdown.new
