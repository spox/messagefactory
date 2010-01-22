# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/Created'

class CreatedTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Created.new
    end

    def test_good
        string = ':not.configured 003 spox :This server was created Tue Mar 24 2009 at 15:42:36 PDT'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(:created, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_kind_of(Time, m.created)
    end

    def test_bad
        string = 'bad string'
        assert_raise(RuntimeError) do
            @handler.process(string)
        end
    end
end
