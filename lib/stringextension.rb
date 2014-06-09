# encoding: UTF-8

# Some extensions to the String class by
# Hermann A. F a ß, hf@domain (domain is vonabiszet.de).

# Extpanding the String class by methods to remove special characters
# and thereby make the string 7-bit or URL safe.
class String

    # Add some methods of the UnicodeString class to the String class.
    # This implicitely instanciates UnicodeString in the background.
    [
        :to_bin, :to_hex, :to_dec,
        :to_ascii, :to_ascii!,
        :to_base_filename, :to_base_filename!,
        :urlify, :urlify!,
        :unicode_upcase, :unicode_upcase!,
        :unicode_downcase, :unicode_downcase!,
        :unicode_capitalize, :unicode_capitalize!
    ].each do |method|
        send :define_method, method do
            UnicodeString.new(self).send method
        end
    end

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

end # End class String



# Class to analyse single characters. All methods work also on
# multibyte characters and thereby allow the analysis of Unicode
# characters.
class UnicodeChar < String

    # Returns a string represention of the binary value of this UnicodeChar
    # instance.
    # The parameter byte_separator contains a string that is used to separate
    # the individual bytes in case this UnicodeChar describes a multibyte
    # character.
    # This separator can be overwritten by a string parameter passed to this
    # method.
    def to_bin( byte_separator = ' ' )
        self.unpack("B8B8B8B8").reject {|b| b == ''}.join(byte_separator)
    end

    # Returns a string representing the hexadecimal value of this Unicode
    # character.
    # The parameter byte_separator contains a string that is used to separate
    # the individual bytes in case this UnicodeChar describes a multibyte
    # character.
    def to_hex( byte_separator = ' ' )
        self.unpack("H2H2H2H2").reject {|h| h == ''}.join(byte_separator).upcase
    end

    # Returns a string representing the decimal value of this Unicode character.
    # For multibyte characters the representation of the individual bytes are
    # separated by a single space character.
    # This separator can be overwritten by a string parameter.
    def to_dec( byte_separator = ' ' )
        self.unpack("C*").join(byte_separator)
    end

    # Test if this Unicode character consists of multiple bytes.
    def multibyte?
        self.bytesize > self.size
    end

end  # End class UnicodeChar


# Class to represent Strings that contain characters beyond ASCII.
#--
# Did not want to add this to String due to the class variables,
# i.e. to keep the name space a bit cleaner.
#++
class UnicodeString < String

    @@uppercase_letters = {
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

    @@lowercase_letters = {}
    # Note the special behaviour of 'ß' which becomes a double character
    # ('SS') in uppercase.
    @@uppercase_letters.each_key do |c|
        @@lowercase_letters[@@uppercase_letters[c]] = c
    end
    @@lowercase_letters['ß'] = 'ß'

    @@ascii_replacements = {
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

    # Returns the content of this instance, replacing all characters that are
    # not 7-bit-safe by an adequate String value from the ASCII character set.
    # This concerns mainly accented letters, umlauts, or ligatures
    # including the German 'Sharp S'.
    def to_ascii()
        str = String.new( self )
        @@ascii_replacements.each do |c, ascii|
            c.each do |s|
                str.gsub!(s, ascii)
            end
        end
        return str
    end

    # Sets the value of this instance to the return value of its
    # to_ascii() method.
    def to_ascii!()
        self.replace( self.to_ascii )
    end

    # Return a representation of this instance's content with all characters
    # that could cause problems or inefficiencies as part of a URL.
    # Spaces are replaced by hyphens (not underscores) to support SEO.
    def urlify
        self.to_ascii.gsub(/\s+/, '-').gsub(/[^\w\-_]/, '_')
    end

    # Replaces the value of this instance with the return value of
    # urlify().
    def urlify!
        self.replace( self.urlify )
    end

    # Return a representation of this instance's content with all characters
    # removed that could cause problems or inefficiencies as part of a
    # filename. Similar to
    # urlify, but the dot is removed (leaving it for the suffix only)
    # and words are connected by underscore characters (not hyphens).
    def to_base_filename()
        self.to_ascii.gsub(/\s+/, '_').gsub(/[^\w\-_\.]/, '_')
    end

    # Replaces the value of this instance by the return value of
    # to_base_filename().
    def to_base_filename!()
        self.replace( self.to_base_filename() )
    end

    # Returns all characters from this UnicodeString instance
    # as an Array of UnicodeChar objects.
    # A multibyte character will be one element of this Array
    # (we are in a $KCODE=='u' environment).
    def unicode_chars
      result = []
      self.split(//).each do |char|
          result.push( UnicodeChar.new(char) )
      end
      result
    end


    # Returns a binary representation (sequence of 0 and 1 digits)
    # of this UnicodeString instance, i.e. of this text.
    # The parameter char_separator is used to separate the binary
    # representations of individual characters.
    # The parameter byte_separator is used to separate the binary
    # representation of the individual bytes of a multibyte string
    # where applicable.
    def to_bin( char_separator = ' ', byte_separator = '.' )
        bin_chars = self.unicode_chars.collect { |uc| uc.to_bin(byte_separator) }
        bin_chars.join(char_separator)
    end

    # Returns a hexadecimal representation of this UnicodeString
    # instance, i.e. of this text.
    # The parameter char_separator is used to separate the
    # hexadecimal representations of individual characters.
    # The parameter byte_separator is used to separate the
    # hexadecimal representation of the individual bytes of
    # a multibyte string where applicable.
    def to_hex( char_separator = ' ', byte_separator = '.' )
        hex_chars = self.unicode_chars.collect { |uc| uc.to_hex(byte_separator) }
        hex_chars.join(char_separator)
    end

    # Returns a decimal representation of this UnicodeString
    # instance, i.e. of this text.
    # The parameter char_separator is used to separate the
    # hexadecimal representations of individual characters.
    # The parameter byte_separator is used to separate the
    # hexadecimal representation of the individual bytes of
    # a multibyte string where applicable.
    def to_dec( char_separator = ' ', byte_separator = '.' )
        dec_chars = self.unicode_chars.collect { |uc| uc.to_dec(byte_separator) }
        dec_chars.join(char_separator)
    end

    # Return the all-uppercase pendent of this UnicodeString.
    # This treats also non-ASCII characters well!
    def unicode_upcase() 
        new_str = ''
        each_char do |c|
            new_str << ( (@@uppercase_letters[c]) ? @@uppercase_letters[c] : c.upcase )
        end
        new_str
    end

    # Replace the value of this UnicodeString by the return value
    # of its unicode_upcase().
    def unicode_upcase!()
        self.replace( self.unicode_upcase )
    end

    # Return the all-lowercase version of this UnicodeString.
    # This treats also non-ASCII characters well!
    def unicode_downcase() 
        new_str = ''
        each_char do |c|
            new_str << ( (@@lowercase_letters[c]) ? @@lowercase_letters[c] : c.downcase )
        end
        new_str
    end

    # Replace the value of this instance by the return value of
    # its unicode_downcase() method.
    def unicode_downcase!()
        self.replace( self.unicode_downcase )
    end

    # Returns the value of this instance with the first character
    # turned into uppercase letter (if it is a letter) and the prepending
    # letters turned into the corresponding lowercase letter.
    # This treats also non-ASCII initials well.
    def unicode_capitalize()
        self[0].unicode_upcase() + self[1..self.length].unicode_downcase()
    end

    # Replace the value of this instance by the return value of
    # its unicode_capitalize() method.
    def unicode_capitalize!()
        self.replace( self.unicode_capitalize() )
    end

end # End class UnicodeString

