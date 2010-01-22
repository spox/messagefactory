$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/Join'

class JoinTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Join.new
    end
    def test_types
        assert_equal(@handler.types_process, :JOIN)
    end
    def test_good
        string = ':mod_spox!~mod_spox@host JOIN :#m'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:join, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('mod_spox!~mod_spox@host', m.source)
        assert_equal('#m', m.channel)
    end
    def test_bad
        string = 'bad string'
        assert_raise(RuntimeError) do
            @handler.process(string)
        end
    end
end
