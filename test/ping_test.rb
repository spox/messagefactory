# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/PING'

class PingTest < Test::Unit::TestCase
  def setup
    @handler = MessageFactory::Handlers::Ping.new
  end
  def test_types
    assert_equal(@handler.types_process, :PING)
  end
  def test_with_server
    string = ':not.configured PING :test'
    m = @handler.process(string)
    assert_kind_of(OpenStruct, m)
    assert_equal(string, m.raw)
    assert_kind_of(Time, m.received)
    assert_equal(:ping, m.type)
    assert_equal(:incoming, m.direction)
    assert_equal('not.configured', m.server)
    assert_equal('test', m.message)
  end
  def test_without_server
    string = 'PING :not.configured'
    m = @handler.process(string)
    assert_kind_of(OpenStruct, m)
    assert_equal(string, m.raw)
    assert_kind_of(Time, m.received)
    assert_equal(:ping, m.type)
    assert_equal(:incoming, m.direction)
    assert_equal('not.configured', m.server)
    assert_equal('not.configured', m.message)
  end
  def test_bad
    assert_raise(RuntimeError) do
      @handler.process('bad string')
    end
  end
end
