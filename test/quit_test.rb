# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/QUIT'

class QuitTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Quit.new
    end
    def test_types
        assert_equal(@handler.types_process, :QUIT)
    end
    def test_message
        string = ':spox!~spox@host QUIT :Ping timeout'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:quit, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@host', m.source)
        assert_equal('Ping timeout', m.message)
    end
    def test_no_message
        string = ':spox!~spox@host QUIT :'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:quit, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@host', m.source)
        assert(m.message.empty?)
    end
    def test_malformed
        string = ':spox!~spox@host QUIT'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:quit, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('spox!~spox@host', m.source)
        assert(m.message.empty?)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('bad string')
        end
    end
end