
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Factory'

# TODO: Should have an array filled with all message types and test to run
# => through all of them and ensure proper loading and processing

class FactoryTest < Test::Unit::TestCase

    def test_autoload
        factory = MessageFactory::Factory.new
        res = factory.process(':not.configured 001 spox :Welcome to the unconfigured IRC Network spox!~spox@192.168.0.107')
        assert_kind_of(MessageFactory::Message, res)
    end

    def test_autoload_failure
        factory = MessageFactory::Factory.new
        assert_raise(NoMethodError) do
            factory.process('failure message')
        end
    end

end
