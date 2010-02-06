# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'test/unit'
require 'Handler'
require 'handlers/Notice'

class NoticeTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Notice.new
    end
    def test_types
        assert_equal(@handler.types_process, :NOTICE)
    end
    def test_public
        string = ':spox!~spox@some.host NOTICE #mod_spox :test'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:notice, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@some.host', m.source)
        assert_equal('#mod_spox', m.target)
        assert_equal('test', m.message)
    end
    def test_private
        string = ':spox!~spox@some.host NOTICE spax :test'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:notice, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@some.host', m.source)
        assert_equal('spax', m.target)
        assert_equal('test', m.message)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('bad string')
        end
    end
end
