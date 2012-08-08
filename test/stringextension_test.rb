# encoding: utf-8

require 'test/unit'
$:.push(File.join('..', 'lib'))
require 'stringextension'

class StringextensionTest < Test::Unit::TestCase

  def setup
    @short_test_str = "Hello.\nHere we are.\nWhere are you?"
    @long_test_str = "This is a String for testing the " <<
                     "String class after it is being " <<
                     "extended by stringextension.rb."
  end

  def test_wrap
    assert_equal(
                  #123456789_123456789_
                  "This is a String for\n" +
                  "testing the String\n" +
                  "class after it is\n" +
                  "being extended by\n" +
                  "stringextension.rb.\n",
                  @long_test_str.wrap(20)
                )
    assert_equal( "Hello.\nHere we are.\nWhere are\nyou?\n",
                  @short_test_str.wrap(12) )
  end

  def test_to_ascii
    assert_equal( 'Moetoerheaed vom Fass', 'Mötörhéäd vom Faß'.to_ascii)
  end

  def test_urlify
    assert_equal("L_Alsace---pas-tres-Francais", "L'Alsace - pas très Français".urlify)
  end

  def test_indent
    assert_equal(" eins\n zwei\n drei", " eins\nzwei\n   drei".indent(1))
    assert_equal(" eins\n  zwei\n   drei", "eins\n zwei\n  drei".indent(1, true))
  end

end

