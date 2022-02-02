    require 'json'
    require_relative './reference.rb'

    # # Short references
    # [APA-style](https://libguides.murdoch.edu.au/APA/text)
    # [examples](https://libguides.murdoch.edu.au/APA/examples)
    # [#5!] = Ward and Ramachandran (2010, December)
    # [#5] = (Ward & Ramachandran, 2010, December)
    # [#5&6] = (Ward & Ramachandran (2010, December) and Agrawal et al. (2015))
    # 3 or more authors -> et al., instead if would create ambiguity (e.g. Name et al (2010) and Name et al. (2010) referring to different papers)


    # Parses the json to short reference format
class ShortParser
    def initialize(contents)
        @parsed = JSON.parse(contents)
    end

    # [#5!] = Ward and Ramachandran (2010, December)
    def parse
        @style = :in_text
        parse_references
    end

    # [#5] = (Ward & Ramachandran, 2010, December) 
    def parsePar
        @style = :parantheses
        @sub_style = :single
        parse_references
    end
    
    # [#5&6!] = Ward and Ramachandran (2020, December) and Agrawal et al. (2015)
    def parseMultiple(indexes)
        @style = :in_text
        parsed = parse_references
        reference = ""
        if indexes.respond_to? :each
            i = 0
            indexes.each do |index|
                index = Integer(index)
                if parsed[index].nil?
                    raise RuntimeError.new("Found nil at #{index}")
                    break 
                end
                if i == 0
                    reference << parsed[index].ref
                    i += 1
                elsif i == indexes.count - 1
                    reference << " and #{parsed[index].ref}" 
                    i += 1
                else
                    reference << ", #{parsed[index].ref}"
                    i += 1
                end

            end
        end
        reference
    end

    # [#5&6] = (Ward & Ramachandran, 2010, December; Agrawal et al., 2015)
    def parseMultiplePar(indexes)
        @style = :parantheses
        @sub_style = :multiple
        parsed = parse_references
        reference = ""
        if indexes.respond_to? :each
            i = 0
            indexes.each do |index|
                index = Integer(index)
                if i == 0
                    reference << parsed[index].ref
                    i += 1
                else
                    reference << "; #{parsed[index].ref}"
                    i += 1

                end
            end
        end
        "(#{reference})"
    end

    private
    # Parses all references
    def parse_references
        references = Hash.new()

        for ref in @parsed
            # References stores the string value of the reference
            reference = parse_ref(ref)

            references.store(ref["uid"], Reference.new(ref["used"], reference))

        end

        # Look for duplicates
        references.each do |key, base| 
            references.each do |key_c, compare|
                # Compare base and compare
                if base.ref == compare.ref && key != key_c
                    STDERR.puts "Found equal references: #{base.ref} and #{compare.ref}"
                    # If equal, change both to add another author, otherwise, ask the user to append a character to the year
                    @parsed.each do |ref|
                        if ref["uid"] == key 
                            references[key] = parse_more(ref)
                        elsif ref["uid"] == key_c
                            references[key_c] = parse_more(ref)
                        end
                    end
                end
            end
        end
        
        references
    end

    # Parses one reference
    def parse_ref(ref) 
        # TODO: convert to the correct format
        case @style
        # [#5!] = Ward and Ramachandran (2010, December)
        when :in_text
            return parse_in_text(ref)
        when :parantheses
            return parse_parantheses(ref)
        end
    end

    def parse_in_text(ref)
        authors = ref["authors"]
        if authors.count() < 3
            author_s = ""
            if authors.respond_to? :each
                authors.each_with_index do |author, index|
                    if index == 0
                        author_s << author
                    else 
                        author_s << " and #{author}"
                    end
                end
            else
                author_s << authors
            end

            reference = "#{author_s} (#{ref["year"]})"

            return reference
        else
            author = authors[0]
            author << " et al."
            year = ref["year"]

            reference = "#{author} (#{year})"

            return reference
        end
    end

    def parse_parantheses(ref)
        authors = ref["authors"]
        if authors.count() < 3
            author_s = ""
            if authors.respond_to? :each
                authors.each_with_index do |author, index|
                    if index == 0
                        author_s << author
                    else 
                        author_s << " & #{author}"
                    end
                end
            else
                author_s << authors
            end

            reference = "#{author_s}, #{ref["year"]}"

            if @sub_style == :single
                reference = "(#{reference})"
            end

            return reference
        else
            author = authors[0]
            author << " et al."
            year = ref["year"]

            reference = "#{author}, #{year}"
            if @sub_style == :single
                reference = "(#{reference})"
            end

            return reference
        end
    end

    def parse_more(ref) 
        raise RuntimeError.new("Unimplemented; same authors in same year is unimplemented. Feel free to open a pull request addressing this issue.")
        case @style
        when :in_text
        end
    end
end
