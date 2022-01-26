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
# -u            Outputs the references without styling
# -i [index]    Outputs the reference with the specified index
# -s            Outputs the short version of the reference for referencing
#               inside of text

require_relative './parser.rb'
require_relative './OS.rb'

class CLI
  def initialize(stored, db_path)
    @refs_path = stored
    @db_path = db_path
  end

  def parse
    # Read stored before all else, just for speed
    if ARGV[0].nil?
      puts read(@refs_path, @color)
      @subcommand = :stored
    end

    ARGV.each_with_index do |var, idx|
      if @subcommand == nil
        case var
        when "read"
          @subcommand = :read
        when "save"
          @subcommand = :save
        when "-u" # Uncolored output
          @color = false
        when "-i"
          @subcommand = :index
        when "-s"
          @short = true
        when "--short"
          @short = true
        when "-h"
          @help = true
        when "--help"
          @help = true
        end
      else
        # Parse arguments for subcommand
        if @subcommand == :read
          @refs_path = var
          @subcommand = nil
        elsif @subcommand == :save
          # Save the whole path to the config dir
          var = File.expand_path(var)
          File.write(@db_path, var)
          puts "Saved path for easy access"
          exit(0)
        elsif @subcommand == :index
          @select = var
          @subcommand = nil
        else
          raise RuntimeError.new("Unkwown subcommand")
        end
      end
    end

    if @help
      puts "Help is unimplemented"
      exit(0)
    end

    if @subcommand.nil? && (@short == nil || !@short)
      refs = read(@refs_path, @color)
      if @select == nil
        puts refs
      else
        puts refs[/\[#{@select}\] .*/]
      end
    elsif (@subcommand.nil? && @short == true)
      puts "short version coming soon"
      # TODO
      # Short ref
      # refs = read_short(@stored, @select == nil ? @color : false)
      # if @select == nil
      #   puts refs
      # else
      #   puts refs[/\[#{@select}\] .*/]
      # end
    else
      puts "You might have a syntax error in your command"
    end

  end
end

def read(file, styled)
  styled = styled == nil ? true : styled

  contents = File.read(file)

  parsed =  FullParser.new(contents).parse_references

  s = String.new()
  if parsed.respond_to?("each")
    for key, ref in parsed
      if styled
        if ref.used
          s += "[#{key}] \e[36m#{ref.ref}\e[0m"
        else
          s += "[#{key}] \e[31m#{ref.ref}\e[0m"
        end
      else
        s += "[#{key}] #{ref.ref}"
      end
      s += "\n"
    end
  else
    raise RuntimError.new("\e[36mNOTE\e[31m: Not yet supported")
  end
  s
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
