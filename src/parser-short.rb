require 'json'
require_relative './reference.rb'

# TODO: warn when two references have the same citation and potentially add (year[a-z]) and/or expand the reference.

# # Short references
# [#5!] = Ward and Ramachandran (2010, December)
# [#5] = (Ward & Ramachandran 2010, December)
# [#5&6!] = Ward and Ramachandran (2010, December) and Agrawal et al. (2015)
# [#5&6] = (Ward & Ramachandran (2010, December); Agrawal et al. (2015))
# 3 or more -> first time: (A, B & C, 1977)
# Second time -> (A et al., 1977)
# 6 or more -> (A et al., 1977)
#
# contents: String (JSON)
class ShortParser 
    def initialize(contents)
        @parsed = JSON.parse(contents)
    end

    # Parse [#1!] -> Name (year)
    # reference: int
    # first: bool
    def parse(reference, first)
        @first = first
        @style = :in_text
        @references = [reference]
        parse_references
    end

    # Parse [#1] -> (Name, year)
    def parsePar(reference, first)
        @style = :parantheses
        @first = first
        @references = [reference]
        parse_references
    end

    private
    def parse_references
        if @references.length == 1
            if @style == :in_text
                parse_in_text(@references[0], @first)
            else
                parse_par(@references[0], @first)
            end
        else
            raise RuntimeError.new "unimplemented"
            if @style == :in_text
                puts "1 author, in text"
            else
                puts "1 author, parentheses"
            end 
        end
    end

    # Parses one reference in the form of `Authors (year)`
    # first: bool
    def parse_in_text(ref_id, first)
        reference = @parsed.detect { |hash| hash['uid'] == ref_id.to_i }
        authors = reference["authors"]
        year = reference["year"]

        # Parse athor name to remove initials
        authors.map { |author|
            # TODO: test if is a match before assigning a value
            if author =~ /,.*/
                author[/,.*/] = ""
            end
            author
        }

        reference = ""
        if first 
            if authors.length >= 6 
                reference << authors[0]
                reference << " et al."
                reference << " (#{year})"
            else
                authors.each_with_index do |author, idx|
                    if authors.length == 1 
                        reference << author
                    elsif idx != authors.length - 1
                        if idx != 0 
                            reference << ", "
                        end
                        reference << author
                    else 
                        reference << " and "
                        reference << author
                    end
                end
                reference << " (#{year})"
            end
        else
            if authors.length >= 3 
                reference << authors[0]
                reference << " et al."
                reference << " (#{year})"
            else
                authors.each_with_index do |author, idx|
                    if authors.length == 1 
                        reference << author
                    elsif idx != authors.length - 1
                        if idx != 0 
                            reference << ", "
                        end
                        reference << author
                    else 
                        reference << " and "
                        reference << author
                    end
                end
                reference << " (#{year})" 
            end
        end
        reference
    end

    # Parses one reference in the form of `Authors, year`.
    # Parentheses still need to be added 
    # first: bool
    def parse_par(ref_id, first)
        reference = @parsed.detect { |hash| hash['uid'] == ref_id.to_i }
        authors = reference["authors"]
        year = reference["year"]

        # Parse athor name to remove initials
        authors.map { |author|
            if author =~ /,.*/            
                author[/,.*/] = ""
            end
            author
        } 

        reference = ""
        if first 
            if authors.length >= 6 
                reference << authors[0]
                reference << " et al."
                reference << ", #{year}"
            else
                authors.each_with_index do |author, idx|
                    if authors.length == 1 
                        reference << author
                    elsif idx != authors.length - 1
                        if idx != 0
                            reference << ", "
                        end
                        reference << author
                    else
                        reference << " & "
                        reference << author
                    end
                end
                reference << ", #{year}"
            end
        else
            if authors.length >= 3
                reference << authors[0]
                reference << " et al."
                reference << ", #{year}"
            else
                authors.each_with_index do |author, idx|
                    if authors.length == 1 
                        reference << author
                    elsif idx != authors.length - 1
                        if idx != 0
                            reference << ", "
                        end
                        reference << author
                    else
                        reference << " & "
                        reference << author
                    end
                end
                reference << ", #{year}"
            end
        end
        reference
    end
end

# Debugging
if __FILE__ == $0
    puts ShortParser.new(File.read("/Users/jonaseveraert/Library/Mobile Documents/com~apple~CloudDocs/Documenten/UGent/Master thesis/Papers/References.json"))
        .parse(5, false)
end