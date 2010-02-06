# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'Handler'
require 'handlers/Names'

class NamesTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Names.new
    end
    def test_types
        assert(@handler.types_process.include?(:'353'))
        assert(@handler.types_process.include?(:'366'))
    end
    def test_good
        start = ':swiftco.wa.us.dal.net 353 spox = #mod_spox :mod_spox spox'
        stop = ':swiftco.wa.us.dal.net 366 spox #mod_spox :End of /NAMES list.'
        assert_nil(@handler.process(start))
        m = @handler.process(stop)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:incoming, m.direction)
        assert_equal(:names, m.type)
        assert(m.raw.include?(start))
        assert(m.raw.include?(stop))
        assert_equal('spox', m.target)
        assert(m.nicks.include?('mod_spox'))
        assert(m.nicks.include?('spox'))
        assert_equal('#mod_spox', m.channel)
    end
    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('some bad string')
        end
    end
end
