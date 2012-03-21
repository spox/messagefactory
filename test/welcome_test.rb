# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/001'

class WelcomeTest < Test::Unit::TestCase
  def setup
    @handler = MessageFactory::Handlers::Welcome.new
  end
  def test_types
    assert_equal(@handler.types_process, :'001')
  end
  def test_good
    string = ':not.configured 001 spox :Welcome to the unconfigured IRC Network spox!~spox@192.168.0.107'
    m = @handler.process(string)
    assert_kind_of(OpenStruct, m)
    assert_kind_of(Time, m.received)
    assert_equal(:incoming, m.direction)
    assert_equal(:welcome, m.type)
    assert_equal('not.configured', m.server)
    assert_equal('spox', m.target)
    assert_equal('Welcome to the unconfigured IRC Network', m.message)
    assert_equal('spox!~spox@192.168.0.107', m.user)
  end
  def test_bad
    string = 'bad message'
    assert_raise(RuntimeError) do
      @handler.process(string)
    end
  end
end
