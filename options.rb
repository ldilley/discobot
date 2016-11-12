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

require 'yaml'

class Options
  def self.parse
    begin
      cfg_file = YAML.load_file('cfg/discobot.yml')
    rescue => e
      puts 'Unable to open discobot.yml!'
      exit!
    end
    @client_id = cfg_file['client_id']
    @token = cfg_file['token']
    @prefix = cfg_file['prefix']
    @owner_id = cfg_file['owner_id']
    @status = cfg_file['status']
    if @client_id.nil?
      puts 'Unable to read client_id option from discobot.yml!'
      exit!
    end
    if @token.nil?
      puts 'Unable to read token option from discobot.yml!'
      exit!
    end
    if @prefix.nil?
      puts 'Unable to read prefix option from discobot.yml!'
      exit!
    end
    if @owner_id.nil?
      puts 'Unable to read owner_id option from discobot.yml!'
      exit!
    end
  end

  class << self
    attr_reader :client_id, :token, :prefix, :owner_id, :status
  end
end
