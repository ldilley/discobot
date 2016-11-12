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

# Reports bot uptime
class Uptime
  def initialize
    @start_time = Time.now.to_i # FixMe: Move this variable to a static location so it does not reset on reload.
  end

  def init(bot)
    bot.command(:uptime) do |event|
      current_time = ::Time.now.to_i
      delta = current_time - @start_time
      days = delta / (60 * 60 * 24) # 60 seconds in a minute, 60 minutes in an hour, 24 hours in a day
      delta -= days * 60 * 60 * 24
      hours = delta / (60 * 60)
      delta -= hours * 60 * 60
      minutes = delta / 60
      delta -= minutes * 60
      seconds = delta
      bot.send_message(event.channel.id, "I have been grooving for #{days} day(s), #{hours} hour(s), #{minutes} minute(s), and #{seconds} second(s).")
    end
  end
end
Uptime.new
