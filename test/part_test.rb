# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/PART'
# :nodoc: :mod_spox!~mod_spox@host PART #m :
        # :nodoc: :foobar!~foobar@some.host PART #php
class PartTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Part.new
    end
    def test_types
        assert_equal(@handler.types_process, :PART)
    end
    def test_part_message
        string = ':mod_spox!~mod_spox@host PART #m :test'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:part, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('mod_spox!~mod_spox@host', m.source)
        assert_equal('#m', m.channel)
        assert_equal('test', m.message)
    end

    def test_part_no_message
        string = ':mod_spox!~mod_spox@host PART #m :'
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:part, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('mod_spox!~mod_spox@host', m.source)
        assert_equal('#m', m.channel)
        assert(m.message.empty?)
    end

    def test_part_empty_message
        string = ':mod_spox!~mod_spox@host PART #m '
        m = @handler.process(string)
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:part, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('mod_spox!~mod_spox@host', m.source)
        assert_equal('#m', m.channel)
        assert(m.message.empty?)
    end

    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('some bad string')
        end
    end
end
