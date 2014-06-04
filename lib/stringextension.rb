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

  # Return the uppercase pendent of a letter.
  # This includes non-ASCII characters!
  #--
  # Highly inefficient. 
  # Consider moving the Hash uppercase_letter to a class variable
  # and thus assign it only once.
  #++
  def upcase_unicode()
    uppercase_letter = {
        "\u00DF" => 'SS',      #  ß
        "\u00E0" => "\u00C0",  #  à   c3 a0   LATIN SMALL LETTER A WITH GRAVE
        "\u00E1" => "\u00C1",  #  á   c3 a1   LATIN SMALL LETTER A WITH ACUTE
        "\u00E2" => "\u00C2",  #  â   c3 a2   LATIN SMALL LETTER A WITH CIRCUMFLEX
        "\u00E3" => "\u00C3",  #  ã   c3 a3   LATIN SMALL LETTER A WITH TILDE
        "\u00E4" => "\u00C4",  #  ä   c3 a4   LATIN SMALL LETTER A WITH DIAERESIS
        "\u00E5" => "\u00C5",  #  å   c3 a5   LATIN SMALL LETTER A WITH RING ABOVE
        "\u00E6" => "\u00C6",  #  æ   c3 a6   LATIN SMALL LETTER AE
        "\u00E7" => "\u00C7",  #  ç   c3 a7   LATIN SMALL LETTER C WITH CEDILLA
        "\u00E8" => "\u00C8",  #  è   c3 a8   LATIN SMALL LETTER E WITH GRAVE
        "\u00E9" => "\u00C9",  #  é   c3 a9   LATIN SMALL LETTER E WITH ACUTE
        "\u00EA" => "\u00CA",  #  ê   c3 aa   LATIN SMALL LETTER E WITH CIRCUMFLEX
        "\u00EB" => "\u00CB",  #  ë   c3 ab   LATIN SMALL LETTER E WITH DIAERESIS
        "\u00EC" => "\u00CC",  #  ì   c3 ac   LATIN SMALL LETTER I WITH GRAVE
        "\u00ED" => "\u00CD",  #  í   c3 ad   LATIN SMALL LETTER I WITH ACUTE
        "\u00EE" => "\u00CE",  #  î   c3 ae   LATIN SMALL LETTER I WITH CIRCUMFLEX
        "\u00EF" => "\u00CF",  #  ï   c3 af   LATIN SMALL LETTER I WITH DIAERESIS
        "\u00F0" => "\u00D0",  #  ð   c3 b0   LATIN SMALL LETTER ETH
        "\u00F1" => "\u00D1",  #  ñ   c3 b1   LATIN SMALL LETTER N WITH TILDE
        "\u00F2" => "\u00D2",  #  ò   c3 b2   LATIN SMALL LETTER O WITH GRAVE
        "\u00F3" => "\u00D3",  #  ó   c3 b3   LATIN SMALL LETTER O WITH ACUTE
        "\u00F4" => "\u00D4",  #  ô   c3 b4   LATIN SMALL LETTER O WITH CIRCUMFLEX
        "\u00F5" => "\u00D5",  #  õ   c3 b5   LATIN SMALL LETTER O WITH TILDE
        "\u00F6" => "\u00D6",  #  ö   c3 b6   LATIN SMALL LETTER O WITH DIAERESIS
        "\u00F8" => "\u00D8",  #  ø   c3 b8   LATIN SMALL LETTER O WITH STROKE
        "\u00F9" => "\u00D9",  #  ù   c3 b9   LATIN SMALL LETTER U WITH GRAVE
        "\u00FA" => "\u00DA",  #  ú   c3 ba   LATIN SMALL LETTER U WITH ACUTE
        "\u00FB" => "\u00DB",  #  û   c3 bb   LATIN SMALL LETTER U WITH CIRCUMFLEX
        "\u00FC" => "\u00DC",  #  ü   c3 bc   LATIN SMALL LETTER U WITH DIAERESIS
        "\u00FD" => "\u00DE",  #  ý   c3 bd   LATIN SMALL LETTER Y WITH ACUTE
        "\u00FE" => "\u00DF",  #  þ   c3 be   LATIN SMALL LETTER THORN
    }
    new_str = ''
    self.each_char do |c|
      new_str << (uppercase_letter[c]) ? uppercase_letter[c] : c.upcase()
    end
    new_str
  end

  def upcase_unicode!()
    self.replace( self.upcase_unicode() )
  end

end

