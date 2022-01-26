require 'json'

Reference = Struct.new(:used, :ref)

# Parses the json to full reference format
class FullParser
  def initialize(contents)
    # remove comments (not actually necessary for this JSON parser)
    # comment = /\A *\/\/ *\w*/
    # contents = contents.lines.map(&->(line) {
    #     if !(line =~ comment)
    #       line.strip # remove new line characters
    #     end
    #   }
    # ).compact # Remove empty lines (comments)
    # .join(' ') # Join in one long strip
    # .to_s # To string

    @parsed = JSON.parse(contents)
  end

  def parse_references
    references = Hash.new()
    for ref in @parsed
      @ref = ref

      # References stores the string value of the reference
      reference = if ref["type"] == "article"
        parse_article
      elsif ref["type"] == "web"
        parse_web
      else
        raise RuntimeError.new("ERROR: unkwown article type: #{ref["type"].inspect} for #{ref["title"].inspect}")
      end

      references.store(ref["uid"], Reference.new(ref["used"], reference))

    end
    references
  end

  # Full reference
  def parse_article
    "#{parse_authors} #{parse_year} #{parse_title} #{parse_journal}"
  end

  # Full refererence
  def parse_web
    "#{parse_authors} #{parse_year} #{parse_title} #{parse_webpage}"
  end

  private
  def parse_authors
    output = String.new()
    authors = @ref["authors"]
    authors.each_with_index do |author, i|
      if i < authors.length() - 2
        output += author + ", "
      elsif i == authors.length() - 2
        output += author + " & "
      else # i == authors.length() - 1
        output += author
      end
    end
    output
  end

  def parse_year
    "(" + @ref["year"]+ ")."
  end

  def parse_title
    "#{@ref["title"]}."
  end

  def parse_journal
    output = String.new()
    output += @ref["journal"]
    if @ref["volume"] != nil
      output += ", #{@ref["volume"]}"
    end
    if @ref["issue"] != nil
      output += "(#{@ref["issue"]})"
    end
    if @ref["page"] != nil
      output += ", #{@ref["page"]}"
    end
    output += "."
    output
  end

  # TODO: retrieved on
  def parse_webpage
    "Retrieved from #{@ref["web_link"]}."
  end
end
