# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/MODE'

class ModeTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Mode.new
    end
    def test_types
        assert_equal(@handler.types_process, :MODE)
    end
    def test_good_server
        string = ':spax!~spox@host MODE #m +o spax'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:mode, m.type)
        assert_equal(string, m.raw)
        assert_equal('spax!~spox@host', m.source)
        assert_equal('#m', m.channel)
        assert(m.set)
        assert(!m.unset)
        assert_equal('o', m.modes)
        assert_equal('spax', m.target)
        assert_equal('o', m.nick_mode['spax'])
    end
    def test_good_server_multi
        string = ':spax!~spox@host MODE #m +ov spax spox'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:mode, m.type)
        assert_equal(string, m.raw)
        assert_equal('spax!~spox@host', m.source)
        assert_equal('#m', m.channel)
        assert(m.set)
        assert(!m.unset)
        assert_equal('ov', m.modes)
        assert_equal('spax spox', m.target)
        assert_equal('o', m.nick_mode['spax'])
        assert_equal('v', m.nick_mode['spox'])
    end
    def test_good_self
        string = ':spax MODE spax :+iw'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:mode, m.type)
        assert_equal(string, m.raw)
        assert_equal('spax', m.source)
        assert_equal('spax', m.target)
        assert_nil(m.channel)
        assert(m.set)
        assert(!m.unset)
        assert('iw', m.modes)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('some bad string')
        end
    end
end
