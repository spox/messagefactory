# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/YourHost'

class YourHostTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::YourHost.new
    end
    def test_types
        assert_equal(@handler.types_process, :'002')
    end
    def test_good
        string = ':not.configured 002 spox :Your host is not.configured, running version bahamut-1.8(04)'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:yourhost, m.type)
        assert_equal(string, m.raw)
        assert_equal('spox', m.target)
        assert_equal('not.configured', m.server)
        assert_equal('bahamut-1.8(04)', m.version)
    end
    def test_bad
        string = 'bad string'
        assert_raise(RuntimeError) do
            @handler.process(string)
        end
    end
end
