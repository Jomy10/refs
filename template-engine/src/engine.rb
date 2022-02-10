#!/usr/bin/ruby

# refst 0.0.1
# Citation template CLI
# © Jonas Everaert 2022
#
# USAGE:
#   refst <input>
# 
# ARGS:
#   <input>         is either a file path, or a string
# 
# OPTIONS:
#   -h              Prints this help information
#   -v, --version   Prints the version of the cli
#   -p              Sets a custom path for the refs cli
# 
# ENVIRONMENT VARIABLES
#   STREAM=true     Can be set to false to output the file in one go
#                   instead of as a stream

require_relative '../../src/parser-short.rb'

VERSION = "0.0.1"


class CLI
    def initialize(args)
        @args = args
        @refs_used = Hash.new
    end

    def execute(stream)
        parse

        # TODO: File.open(@input, "r") do |line| ... -> read file line by line
        input = begin
            File.read(@input)
        rescue Errno::ENOENT
            @input
        end
        
        if stream == true
            replace_stream(input)
        else
            replace(input)
        end
    end

    private
    def parse
        @args.each do |arg|
            case arg
            when /-[a-zA-Z]+/
                arg.chars do |char|
                    case char
                    when 'h'
                        STDERR.puts "Help is unimplemented"
                    when 'v'
                        puts "Citation template CLI v#{VERSION}"
                    when 'p'
                        @subcommand = :path
                    end
                end
            else
                if @subcommand.nil?
                    if @input.nil?
                        @input = arg
                    else
                        raise RuntimeError.new("Too many arguments")
                    end
                else
                    if @subcommand == :path
                        @refs_path = arg
                    end
                end
            end
        end


        if @refs_path.nil?
            # If no path is specified for the db, use the default set by refs
            @refs_path = `refs get`
            @refs_path = @refs_path.strip
        end

        @parser = ShortParser.new(File.read(@refs_path))
    end

    def replace_stream(input)
        input.lines.flat_map do |line|
           puts parse_line(line) 
        end
    end

    def replace(input)
        output = input.lines.flat_map do |line|
            parse_line(line)
        end
        output
    end

    def parse_line(line)
        # Match all patterns
        # It's highly unlikely that the same referene will be cited more than once in one line,
        # but it's not 0. This does NOT account for that!
        if match = line[/\[#[0-9]+\!\]/]
            line = replace_matches_single(line, match)
        end
        if match = line[/\[#[0-9]+\]/]
            line = replace_matches_single_par(line, match)
        end
        if match = line[/\[#([0-9]+&)+[0-9]+\!\]/]
            line = replace_matches_multiple(line, match)
        end
        if match = line[/\[#([0-9]+&)+[0-9]+\]/]
            line = replace_matches_multiple_par(line, match)
        end

        line
    end


    def replace_matches_single(line, match)
        number = match[/[0-9]+/]
        short_ref = @parser.parse(number, !@refs_used.key?(number))
        if not @refs_used.key?(number)
            @refs_used[number] = true
        end
        new_line = line.sub(match) { short_ref.strip }

        other_match = new_line[/\[#[0-9]+\!\]/]
        if other_match.nil?
            return new_line
        else
            return replace_matches_single(new_line, other_match) 
        end
    end

    def replace_matches_single_par(line, match)
        number = match[/[0-9]+/]
        short_ref = "(#{@parser.parsePar(number, !@refs_used.key?(number))})"
        if not @refs_used.key?(number)
            @refs_used[number] = true
        end
        new_line = line.sub(match) { short_ref.strip }

        other_match = new_line[/\[#[0-9]+\]/]
        if other_match.nil?
            return new_line
        else
            return replace_matches_single_par(new_line, other_match)
        end
    end

    def replace_matches_multiple(line, match)
        numbers = match[/([0-9]+&)+[0-9]+/]
        numbers = numbers.split('&')
        short_refs = ""
        numbers.each_with_index do |number, idx|
            short_ref = @parser.parsePar(number, !@refs_used.key?(number))
            if not @refs_used.key?(number)
                @refs_used[number] = true
            end
            
            if idx == 0
                short_refs << short_ref
            elsif idx != numbers.length - 1
                short_refs << ", #{short_ref}"
            else
                short_refs << " and #{short_ref}"
            end
        end
        new_line = line.sub(match) { short_refs.strip }

        other_match = new_line[/\[#([0-9]+&)+[0-9]+\!\]/]
        if other_match.nil?
            return new_line
        else
            return replace_matches_multiple(new_line, other_match)
        end
    end

    def replace_matches_multiple_par(line, match)
        numbers = match[/([0-9]+&)+[0-9]+/]
        numbers = numbers.split('&')
        short_refs = "("
        numbers.each_with_index do |number, idx|
            short_ref = @parser.parsePar(number, !@refs_used.key?(number))
            if not @refs_used.key?(number)
                @refs_used[number] = true
            end
            short_refs << short_ref
            if idx != numbers.length - 1
                short_refs << "; "
            end
        end 
        short_refs << ")"
        new_line = line.sub(match) { short_refs.strip }

        other_match = new_line[/\[#([0-9]+&)+[0-9]+\]/]
        if other_match.nil?
            return new_line
        else
            return replace_matches_multiple_par(new_line, other_match)
        end
    end
end

if __FILE__ == $0
    stream = if s = ENV["STREAM"]
        s
    else
        true
    end

    if stream
        CLI.new(ARGV).execute(stream)
    else
        puts CLI.new(ARGV).execute(stream)
    end
end
