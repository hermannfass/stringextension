# encoding: UTF-8
# Some extensions to the String class by
# Hermann A. F a ß, hf@domain (domain is vonabiszet.de).

# Extpanding the String class by methods to remove special characters
# and thereby make the string 7-bit or URL safe.
class String

  # Word wrap to a specified number of maximum characters per line.
  # In case the test already contains newlines those will result
  # in an additional empty line each to keep paragraphs visible.
  def wrap( cols = 72 )
    self.gsub!(/(.{1,#{cols}})( +|$\n?)|(.{1,#{cols}})/, "\\1\\3\n")
    #           -----------   -------   -----------       ------
    #           |             |         |                 |
    #           0-72 chars followed by: |                 |
    #                         |         |                 |
    #                         spaces or a newline or (if that does not exist)
    #                                   |                 |
    #                                  0-72 chars not followed by whitespace
    #                                                     |
    #       Either 0-72 chars (followed by space or not)--/
  end

  # Indent a text block, i.e. prepend a number of spaces (1st argument)
  # to the beginning of each line. If the text is already indented, i.e.
  # if lines are already prepended by whitespace, this can be removed
  # (default) or not (set 2nd argument to true for this).
  def indent( cols = 2, leave_existing_indentation = false )
    old_str = self
    new_str = ''
    self.each_line do |l|
      l.lstrip! unless (leave_existing_indentation)
      new_str << ' '*cols + l
    end
    self.replace( new_str )
  end
  
  # Replace all letters of this String that are not 7-bit safe by an
  # adequate String value from the ASCII character set.
  # This concerns mainly accented letters, umlauts, or ligatures
  # including the German 'Sharp S'.
  def to_ascii
    str = String.new( self )
    replacements = {
      ['á', 'à', 'â', 'ã'] => 'a',
      ['ä', 'æ'] => 'ae',
      ['Á', 'À', 'Â', 'Ã'] => 'A',
      ['Ä', 'Æ'] => 'Ae',
      ['ç'] => 'c',
      ['Ç'] => 'C',
      ['é', 'è', 'ê', 'ë'] => 'e',
      ['É', 'È', 'Ê', 'Ë'] => 'E',
      ['í', 'ì', 'î', 'ï'] => 'i',
      ['Í', 'Ì', 'Î', 'Ï'] => 'I',
      ['ó', 'ò', 'ô', 'õ'] => 'o',
      ['ö', 'œ'] => 'oe',
      ['Ó', 'Ò', 'Ô', 'Õ'] => 'O',
      ['Ö', 'Œ'] => 'Oe',
      ['ú', 'ù', 'û'] => 'u',
      ['ü'] => 'ue',
      ['Ú', 'Ù', 'Û',] => 'U',
      ['Ü'] => 'Ue',
      ['ß'] => 'ss',
      ['ñ'] => 'n',
      ['Ñ'] => 'N',
      ['¼'] => 'Quarter',
      ['½'] => 'Half'
    }
    replacements.each do |c, ascii|
      c.each do |s|
        str.gsub!(s, ascii)
      end
    end
    return str
  end

  # Like String#to_ascii(), but makes the String instance itself
  # 7-bit safe. Use this only if you want to change this
  # instance of String (vs. receiving a 7-bit safe copy of it).
  def to_ascii!
    self.replace( self.to_ascii() )
  end
  
  # Return a representation of this String's content with all those characters
  # removed that could cause problems or inefficiencies when being used in
  # URLs.
  # This is also useful when constructing filenames. (Despite of the fact
  # that most OSs support non-7bit characters and spaces it still recommended
  # to make filenames URL safe from the very beginning.)
  # Spaces are replaced by hyphens (not underscores) to support SEO.
  def urlify
    self.to_ascii.gsub(/\s+/, '-').gsub(/[^\w\-_]/, '_')
  end

  # Return a representation of this String's content that is useful to
  # construct a file or directory name. Similar to
  # urlify, but the dot is removed (leaving it for the suffix only)
  # and words are connected by underscore characters (not hyphens).
  def to_base_filename
    self.urlify.gsub('.', '_')
    self.to_ascii.gsub(/\s+/, '_').gsub(/[^\w\-_\.]/, '_')
  end

end

