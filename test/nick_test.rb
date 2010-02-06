# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/NICK'

class NickTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Nick.new
    end
    def test_types
        assert_equal(@handler.types_process, :NICK)
    end
    def test_good
        string = ':spox!~spox@some.random.host NICK :flock_of_deer'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:nick, m.type)
        assert_equal(string, m.raw)
        assert_equal('spox!~spox@some.random.host', m.source)
        assert_equal('flock_of_deer', m.new_nick)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('some bad string')
        end
    end
end
