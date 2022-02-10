#!/usr/bin/ruby

require_relative './parser.rb'
require_relative './OS.rb'
require_relative './parser-short.rb'

# References CLI
#
# Authors: Jonas Everaert <info@jonaseveraert.be>
# License: MIT
#
# ### Refs
# refs          Reads the file set using read
#
# ### Refs [SUBCOMMAND]
# refs [COMMAND] [ARGS] [FLAGS]
#
# COMMANDS
# read [file]   Reads the file
# save [file]   Saves the path for easy access using `refs`
# add <type> <file>
#               Add a reference to either the saved file, or the file given via
#               the parameter. The type specifies the article type. The default
#               is article.
# get           Prints out the path to the currently saved file
# short         Prints out the references in short for for citing references
#               inside of text. Type refs short -h for more info on flags
#
# FLAGS
# -u            Outputs the references without styling
# -i <index>    Outputs the reference with the specified index. 
#               Can be supplied multiple times to get a list of references,
#               or separate numbers with comma's (no spaces).
# -c            Counts the amount of references
# -o            Only shows used references. 
# -s, --search  Searches the references. Accepts regex as an argument
# -n            Outputs the references without numbers
# -h, --help    Prints this help message.
# -v, --version Prints the version of the cli
#
# ### Refs short
# Prints out the references in short for for citing references inside of text.
# refs short [FLAGS]
# 
# FLAGS
# -m <indexes>  Outputs the reference for referencing multiple works. Specify multiple works 
#               using "," e.g. 4,5,7
# -t            Sets the type of short reference (def (= default) or par (= parentheses))
# UNIMPLEMENTED:
# -u            Outputs the references without styling
# -i <index>    Outputs the refernces with the id `index`
# -o            Only shows used references.  
# -r, --search  Searches the references. Accepts regex as an argument
# -n            Outputs the references without number
#
class CLI
  def initialize(stored, db_path)
    @refs_path = stored
    @db_path = db_path
    # The references selected using -i <index>
    @select = Array.new
  end

  def parse
    # Determine action
    ARGV.each_with_index do |var, idx|
      # These subcommands can take multiple arguments, that's why you could go to else block
      # This is currently not perfect and I will rewrite it, probably
      if [:read, :save, :add, :add_article, :add_web, :index, :search].all? { |cond| @subcommand != cond } 
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
        when "--search"
          @subcommand = :search
        when "short"
          raise RuntimeError.new "Parsing short references through the cli is no longer supported, please use the template cli"
          self.parse_short
          exit(0)
        else
          if var.match(/-[a-zA-Z]+/)
            var.chars do |char|
              case char
              when 'u'
                @color = false
              when 'i'
                @subcommand = :index
              when 'h'
                @subcommand = :help
              when 'c'
                @subcommand = :count
              when 'o'
                @only_used = true
              when 's'
                @subcommand = :search
              when 'n'
                @add_numbers = false
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
          STDERR.puts "Saved path for easy access"
          exit(0)
        elsif @subcommand == :index
          input_arr = var.split(",")
          input_arr.each do |input|
            @select << input # Append var to select array
          end
          @subcommand = nil
        elsif @subcommand == :add
          if var == "article"
            @subcommand = :add_article
          elsif var == "web"
            @subcommand = :add_web
          end
        elsif @subcommand == :add_article
          @refs_path = var
        elsif @subcommand == :search
          @search_for = var
        else
          raise RuntimeError.new("Unkwown subcommand")
        end
      end
    end

    # Perform the action
    if @subcommand.nil? && (@short == nil || !@short)
      refs = read(@refs_path, @color, @only_used, @add_numbers)
      if @select.empty?
        puts refs
      else
        @select.each do |sel|
          puts refs[/\[#{sel}\] .*/]
        end
      end
    elsif (@subcommand.nil? && @short == true)
      STDERR.puts "short version coming soon"
      # TODO
      # Short ref
      # refs = read_short(@stored, @select == nil ? @color : false)
      # if @select == nil
      #   puts refs
      # else
      #   @select.each do |sel|
      #       puts refs[/\[#{sel}\] .*/]
      #   end
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
      STDERR.puts "Help is unimplemented"
    elsif @subcommand == :count
      refs = read(@refs_path, @color, @only_used)
      puts refs.lines.count
    elsif @subcommand == :search
      refs = read(@refs_path, @color, @only_used)
      matches = String.new()
      refs.lines do |line|
        if line.match(Regexp.new(@search_for, "i"))
          matches += line
        end
      end
      puts matches
    else
      if @subcommand != :stored
        puts "You might have a syntax error in your command"
      end
    end
  end

  def parse_short
    started = false
    ARGV.each_with_index do |var, idx| 
      if var.match("short")
        started = true
      elsif var.match(/-[a-zA-Z]+/)
        var.chars do |char|
          case char
          when 'u'
            @color = false
          when 'r'
            @subcommand = :references
          when 'm'
            @subcommand = :references
          when 'i'
            @subcommand = :index
          when 'h'
            @subcommand = :help
          when 'o'
            @only_used = true
          when 'n'
            @add_numbers = false
          when 't'
            @subcommand = :type
          end
        end
      else
        case @subcommand
        when :type
          @type = var
        when :references
          @references = var.split(",")
        when :index
          raise RuntimeError.new("-i is unimplemented for short")
        when :help
          raise RuntimeError.new("Help is unimplemented")
        end
      end
    end
    self.execute_short
  end

  def execute_short
    if @references.nil?
      raise RuntimeError.new("Please specify a reference id")
    end
    refs = if @type.nil? || @type == "def" || @type == "default"
      result = read_short(@refs_path, @color, @only_used, @add_numbers, :def, @references)
      # if result.respond_to? :each
      #   result.each do |id, ref| 
      #     puts ref.ref 
      #   end
      # else
      #   puts result
      # end
    elsif @type == "par" || @type == "parentheses"
      result = read_short(@refs_path, @color, @only_used, @add_numbers, :par, @references)
      # if result.respond_to? :each
      #   result.each do |id, ref| 
      #     puts ref.ref
      #   end
      # else
      #   puts result
      # end
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

def read(file, styled, only_used, add_numbers = true)
  add_numbers = add_numbers.nil? ? true : add_numbers 
  styled = styled.nil? ? true : styled

  contents = File.read(file)

  parsed = FullParser.new(contents).parse_references

  s = String.new()
  if parsed.respond_to?("each")
    for key, ref in parsed
      if styled
        if ref.used
          if !add_numbers
            s += "\e[36m#{ref.ref}\e[0m"
          else
            s += "[#{key}] \e[36m#{ref.ref}\e[0m"
          end
        else
          if !only_used
            if !add_numbers
              s += "\e[31m#{ref.ref}\e[0m"
            else
              s += "[#{key}] \e[31m#{ref.ref}\e[0m"
            end
          end
        end
      else
        if !only_used
          if !add_numbers
            s += "[#{ref.ref}"
          else
            s += "[#{key}] #{ref.ref}"
          end
        else
          if ref.used
            if !add_numbers
              s += "[#{ref.ref}"
            else
              s += "[#{key}] #{ref.ref}"
            end
          end
        end 
      end
      if !only_used
        s += "\n"
      else
        if ref.used
          s += "\n"
        end
      end
    end
  else
    raise RuntimError.new("\e[36mNOTE\e[31m: Not yet supported")
  end

  s
end

# references: reference numbers
def read_short(file, styled = true, only_used = false, add_number = true, type = :def, references = [])
  add_numbers = add_numbers.nil? ? true : add_numbers
  styled = styled.nil? ? true : styled

  contents = File.read(file)

  parsed = if type == :def
    if references.empty?
      ShortParser.new(contents).parse(references[0])
    else
      ShortParser.new(contents).parseMultiple(references)
    end
  elsif type == :par
    if references.empty?
      ShortParser.new(contents).parsePar(references[0])
    else
      ShortParser.new(contents).parseMultiplePar(references)
    end
  end

  # TODO: color, etc. (see read)

  parsed
end

# Run
if __FILE__ == $0
  config_dir = OS::Dirs.config

  # create dir if not exist
  system 'mkdir', '-p', "#{config_dir}"
  # exec

  # get stored ref db
  stored_path = "#{config_dir}/db"

  stored = if File.exist?(stored_path)
    File.read(stored_path)
  else
    nil
  end

  CLI.new(stored, stored_path).parse
end
