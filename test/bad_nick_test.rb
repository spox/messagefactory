# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/BadNick'

class BadNickTest < Test::Unit::TestCase
    def setup
        @badnick = MessageFactory::Handlers::BadNick.new
    end

    def test_good
        string = ':the.server 432 spox 999 :Erroneous Nickname'
        m = @badnick.process(string)
        assert_equal('the.server', m.server)
        assert_equal(:badnick, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('999', m.bad_nick)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
    end

    def test_bad
        string = 'random string'
        assert_raise(RuntimeError) do
            @badnick.process(string)
        end
    end
end
