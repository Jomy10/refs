#!/usr/bin/ruby
# References CLI
#
# Authors: Jonas Everaert <info@jonaseveraert.be>
# License: MIT
#
# refs          Reads the file set using read
#
# refs [COMMAND] [ARGS] <FLAGS>
#
# COMMANDS
# read [file]   Reads the file
# save [file]   Saves the path for easy access using `refs`
#
# FLAGS
# -u            Outputs the sources without styling

require_relative './parser.rb'
require_relative './OS.rb'

class CLI
  attr_accessor :stored

  def initialize(stored, db_path)
    @stored = stored
    @db_path = db_path
  end

  def parse
    # Read stored before all else, just for speed
    if ARGV[0].nil?
      read(@stored, @color)
      @subcommand = :stored
    end

    ARGV.each_with_index do |var, idx|
      if @subcommand == nil
        case var
        when "read"
          @subcommand = :read
        when "save"
          @subcommand = :save
        when "-u" # Uncolered output
          @color = false
        end
      else
        if @subcommand == :read
          read(var, @color)
        elsif @subcommand == :save
          # Save the whole path to the config dir
          var = File.expand_path(var)
          File.write(@db_path, var)
        else
          raise RuntimeError.new("Unkwown subcommand")
        end
      end
    end

    if @subcommand == nil
      read(@stored, @color)
    end
  end
end

def read(file, styled)
  styled = styled == nil ? true : styled

  contents = File.read(file)

  parsed =  FullParser.new(contents).parse_references

  if parsed.respond_to?("each")
    for key, ref in parsed
      if styled
        if ref.used
          puts "[#{key}] \e[36m#{ref.ref}\e[0m"
        else
          puts "[#{key}] \e[31m#{ref.ref}\e[0m"
        end
      else
        puts "[#{key}] #{ref.ref}"
      end
    end
  else
    puts "\e[36mNOTE\e[31m: Not yet supported"
  end
end

# Run
if __FILE__ == $0
  config_dir = OS::Dirs.config

  # create dir if not exist
  system 'mkdir', '-p', "#{config_dir}"

  # get stored ref db
  stored_path = "#{config_dir}/db"

  stored = if File.exists?(stored_path)
    File.read(stored_path)
  else
    nil
  end

  CLI.new(stored, stored_path).parse
end
