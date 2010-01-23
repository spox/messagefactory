# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/Inviting'

class InvitingTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Inviting.new
    end
    def test_types
        assert_equal(@handler.types_process, :'341')
    end
    def test_good
        string = ':not.configured 341 spox spox_ #a'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(:incoming, m.direction)
        assert_equal(:inviting, m.type)
        assert_equal('not.configured', m.server)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal('spox', m.source)
        assert_equal('spox_', m.target)
        assert_equal('#a', m.channel)
    end
    def test_bad
        string = 'bad string'
        assert_raise(RuntimeError) do
            @handler.process(string)
        end
    end
end
