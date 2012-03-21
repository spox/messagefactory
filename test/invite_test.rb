$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/INVITE'

class InviteTest < Test::Unit::TestCase
  def setup
    @handler = MessageFactory::Handlers::Invite.new
  end
  def test_good
    string = ':spox!~spox@192.168.0.107 INVITE spox_ :#a'
    m = @handler.process(string)
    assert_kind_of(OpenStruct, m)
    assert_equal(:invite, m.type)
    assert_equal(:incoming, m.direction)
    assert_equal(string, m.raw)
    assert_kind_of(Time, m.received)
    assert_equal('spox!~spox@192.168.0.107', m.source)
    assert_equal('#a', m.channel)
    assert_equal('spox_', m.target)
  end
  def test_bad
    string = 'bad invite'
    assert_raise(RuntimeError) do
      @handler.process(string)
    end
  end
end
