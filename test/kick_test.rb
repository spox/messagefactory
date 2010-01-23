$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/Kick'

class KickTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Kick.new
    end
    def test_types
        assert_equal(@handler.types_process, :KICK)
    end
    def test_good
        string = ':spax!~spox@host KICK #m spox :foo'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:kick, m.type)
        assert_equal(string, m.raw)
        assert_equal('spax!~spox@host', m.source)
        assert_equal('#m', m.channel)
        assert_equal('spox', m.target)
        assert_equal('foo', m.message)
    end
    def test_bad
        string = 'bad string'
        assert_raise(RuntimeError) do
            @handler.process(string)
        end
    end
end
