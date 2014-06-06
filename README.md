# Stringextension

Opens the String class and adds funtionality.

Such additional String features support:
Making Strings 7-bit safe or appropriate for usage in filenames and URLs;
handle text indentation to the String class; allow to transform Strings
with non-ASCII letters to all-uppercase and all-lowercase.

## Installation

Add this line to your application's Gemfile:

    gem 'stringextension'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stringextension

## Usage

    require 'stringextension'
    str = "Maßvolle Änderungen"
    puts str.to_ascii  # Massvolle Aenderungen
    puts str.urlify    # Massvolle-Aenderungen

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

