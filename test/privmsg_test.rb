# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/PRIVMSG'

class PrivmsgTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Privmsg.new
    end
    def test_types
        assert_equal(@handler.types_process, :PRIVMSG)
    end
    def test_to_channel
        string = ':spox!~spox@host PRIVMSG #m :foobar'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:privmsg, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@host', m.source)
        assert_equal('#m', m.target)
        assert_equal('foobar', m.message)
    end
    def test_to_user
        string = ':spox!~spox@host PRIVMSG mod_spox :foobar'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:privmsg, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@host', m.source)
        assert_equal('mod_spox', m.target)
        assert_equal('foobar', m.message)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('bad string')
        end
    end
end
