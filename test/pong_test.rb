# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/PONG'

class PongTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Pong.new
    end
    def test_types
        assert_equal(@handler.types_process, :PONG)
    end
    def test_with_message
        string = ':swiftco.wa.us.dal.net PONG swiftco.wa.us.dal.net :FOO'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:pong, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('swiftco.wa.us.dal.net', m.server)
        assert_equal('FOO', m.message)
    end
    def test_without_message
        string = ':swiftco.wa.us.dal.net PONG swiftco.wa.us.dal.net'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:pong, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('swiftco.wa.us.dal.net', m.server)
        assert(m.message.empty?)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('bad string')
        end
    end
end