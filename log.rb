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

class Log
  DBUG = 0
  INFO = 1
  WARN = 2
  CRIT = 3

  def self.write(severity, text)
    begin
      log_dir = 'logs'
      Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
      case severity
      when 0
        level = 'DBUG'
      when 1
        level = 'INFO'
      when 2
        level = 'WARN'
      when 3
        level = 'CRIT'
      else
        level = 'DBUG'
      end
      log_file = File.open("#{log_dir}/discobot.log", 'a')
      log_file.puts "#{Time.now.strftime("%D %T")} #{level}: #{text}"
      log_file.close
    rescue => exception
      puts "Unable to write to log file: #{exception}"
      #raise
    end
  end
end
