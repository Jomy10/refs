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
# add <type> <file>
#               Add a reference to either the saved file, or the file given via
#               the parameter. The type specifies the article type. The default
#               is article.
# get           Prints out the path to the currently saved file
#
# FLAGS
# -u            Outputs the references without styling
# -i [index]    Outputs the reference with the specified index
# -s            Outputs the short version of the reference for referencing
#               inside of text
# -c            Counts the amount of references
# -o            Only shows used sources. 

require_relative './parser.rb'
require_relative './OS.rb'

class CLI
  def initialize(stored, db_path)
    @refs_path = stored
    @db_path = db_path
  end

  def parse
    # Read stored before all else, just for speed
    # if ARGV[0].nil?
    #   puts read(@refs_path, @color)
    #   @subcommand = :stored
    # end

    # TODO: better parsing, e.g. when starts with - followed by a letter, parse each letter as an argument
    # Determine action
    ARGV.each_with_index do |var, idx|
      if @subcommand == nil
        case var
        when "read"
          @subcommand = :read
        when "save"
          @subcommand = :save
        when "--short" # -s
          @short = true
        when "--help" # -h
          @subcommand = :help
        when "add"
          @subcommand = :add
        when "get"
          @subcommand = :get_file
        else
          if var.match(/-[a-zA-Z]+/)
            var.chars do |char|
              case char
              when 'u'
                @color = false
              when 'i'
                @subcommand = :index 
              when 's'
                @short = true
              when 'h'
                @subcommand = :help
              when 'c'
                @subcommand = :count
              when 'o'
                @only_used = true
              end
            end
          end
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
        elsif @subcommand == :add
          if var == "article"
            @subcommand = :add_article
          elsif var == "web"
            @subcommand = :add_web
          end
        elsif @subcommand == :add_article
          @refs_path = var
        else
          raise RuntimeError.new("Unkwown subcommand")
        end
      end
    end

    # Perform the action
    if @subcommand.nil? && (@short == nil || !@short)
      refs = read(@refs_path, @color, @only_used)
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
    elsif @subcommand == :add || @subcommand == :add_article
      # Default: article
      File.open(@refs_path, 'r+') do |f|
        # Remove last line
        last_line = 0
        f.each { last_line = f.pos unless f.eof? }
        f.seek(last_line, IO::SEEK_SET) # Puts the "cursor" on the start of the last line
        f << add_article()
        f << "]"
      end
    elsif @subcommand == :add_web
      add_web()
    elsif @subcommand == :get_file
      puts @refs_path
    elsif @subcommand == :help
      puts "Help is unimplemented"
    elsif @subcommand == :count
      refs = read(@refs_path, @color, @only_used)
      puts refs.lines.count
    else
      if @subcommand != :stored
        puts "You might have a syntax error in your command"
      end
    end

  end
end

# Returns a JSON object
def add_article
  print "(Title) "
  $stdout.flush
  title = STDIN.gets.chomp

  print "(Authors (in quotes, separated by commas)) "
  $stdout.flush
  authors = STDIN.gets.chomp

  print "(Year) "
  $stdout.flush
  year = STDIN.gets.chomp

  print "(Journal) "
  $stdout.flush
  journal = STDIN.gets.chomp

  print "(Volume) "
  $stdout.flush
  volume = STDIN.gets.chomp

  print "(Issue) "
  $stdout.flush
  issue = STDIN.gets.chomp

  print "(Page) "
  $stdout.flush
  page = STDIN.gets.chomp

  print "(wos_link) "
  $stdout.flush
  wos = STDIN.gets.chomp

  print "(Used) "
  $stdout.flush
  used = STDIN.gets.chomp

  # TODO: automatic
  print "(Uid) "
  $stdout.flush
  uid = STDIN.gets.chomp

  s = String.new()
  s << "  , {\n"
  s << "    \"title\": \"#{title}\",\n"
  s << "    \"authors\": [#{authors}],\n"
  s << "    \"year\": \"#{year}\",\n"
  s << "    \"journal\": \"#{journal}\",\n"
  volume != "" ? s << "    \"volume\": #{volume},\n" : nil
  issue != "" ? s << "    \"issue\": #{issue},\n" : nil
  page != "" ? s << "    \"page\": \"#{page}\",\n" : nil
  wos != "" ? s << "    \"wos_link\": \"#{wos}\",\n" : nil
  s << "    \"used\": #{used},\n"
  s << "    \"uid\": #{uid},\n"
  s << "    \"type\": \"article\"\n"
  s << "  }\n"
  s
end

def add_web
  raise RuntimeError("Web references have not been implemented, you can manually add them to your files")
end

def read(file, styled, only_used)
  styled = styled == nil ? true : styled

  contents = File.read(file)

  parsed = FullParser.new(contents).parse_references

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

  if only_used 
    val = String.new()
    s.lines do |line|
      if line.match(/\e\[36m/)
        val += line
      end
    end
    val
  else
    s
  end
end

# Run
if __FILE__ == $0
  config_dir = OS::Dirs.config

  # create dir if not exist
  system 'mkdir', '-p', "#{config_dir}"
  # exec

  # get stored ref db
  stored_path = "#{config_dir}/db"

  stored = if File.exists?(stored_path)
    File.read(stored_path)
  else
    nil
  end

  CLI.new(stored, stored_path).parse
end
