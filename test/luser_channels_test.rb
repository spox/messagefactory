# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/LuserChannels'

class LuserChannelsTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::LuserChannels.new
    end
    def test_types
        assert_equal(@handler.types_process, :'254')
    end
    def test_good
        string = ':crichton.freenode.net 254 spox 24466 :channels formed'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:luserchannels, m.type)
        assert_equal(string, m.raw)
        assert_equal('crichton.freenode.net', m.server)
        assert_equal('spox', m.target)
        assert_equal('24466', m.num_channels)
        assert_equal('channels formed', m.message)
    end
    def test_bad
        string = 'bad string'
        assert_raise(RuntimeError) do
            @handler.process(string)
        end
    end
end
