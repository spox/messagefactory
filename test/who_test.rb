# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/352'

class WhoTest < Test::Unit::TestCase
    def setup
        @handler = MessageFactory::Handlers::Who.new
    end
    def test_types
        assert(@handler.types_process.include?(:'352'))
        assert(@handler.types_process.include?(:'315'))
        assert_equal(2, @handler.types_process.size)
    end

    def test_nick_who
        string = []
        string << ':swiftco.wa.us.dal.net 352 spox * ~metallic codemunkey.net punch.va.us.dal.net metallic H :2 Sean Grimes'
        string << ':swiftco.wa.us.dal.net 315 spox metallic :End of /WHO list.'
        assert_nil(@handler.process(string[0]))
        m = @handler.process(string[1])
        assert_kind_of(OpenStruct, m)
        assert_equal(string, m.raw)
        assert_kind_of(Time, m.received)
        assert_equal(:who, m.type)
        assert_equal(:incoming, m.direction)
        assert_nil(m.channel)
        assert_equal(1, m.nicks.size)
        assert_equal('metallic', m.nicks[0].nick)
        assert_equal('codemunkey.net', m.nicks[0].host)
        assert_equal('punch.va.us.dal.net', m.nicks[0].irc_host)
        assert_equal(2, m.nicks[0].hops)
        assert_equal('Sean Grimes', m.nicks[0].real_name)
        assert_nil(m.ops)
        assert_nil(m.voice)
        assert_equal(2, m.raw.size)
        assert_equal(string[0], m.raw[0])
        assert_equal(string[1], m.raw[1])
    end

    def test_channel_who
        string = []
        string << ':swiftco.wa.us.dal.net 352 spox #php ~spox pool-96-225-201-176.ptldor.dsl-w.verizon.net swiftco.wa.us.dal.net spox H+ :0 spox'
        string << ':swiftco.wa.us.dal.net 352 spox #php ~nobody headcase.gw.uiuc.edu punch.va.us.dal.net ancker H :2 Nobody'
        string << ':swiftco.wa.us.dal.net 352 spox #php ~chendo 24.47.233.220.static.exetel.com.au punch.va.us.dal.net chendo H@ :2 chendo'
        string << ':swiftco.wa.us.dal.net 315 spox #php :End of /WHO list.'
        3.times{|i| @handler.process(string[i])}
        m = @handler.process(string.last)
        assert_kind_of(OpenStruct, m)
        assert_kind_of(Time, m.received)
        assert_equal(:who, m.type)
        assert_equal(:incoming, m.direction)
        assert_equal('#php', m.channel)
        assert_equal(3, m.nicks.size)
        assert_equal(1, m.ops.size)
        assert_equal(1, m.voice.size)
        assert(m.nicks.include?(m.ops[0]))
        assert(m.nicks.include?(m.voice[0]))
        assert_equal(4, m.raw.size)
        4.times{|i| assert_equal(string[i], m.raw[i])}
    end

    def test_bad
        assert_raise(RuntimeError) do
            @handler.process('bad string')
        end
    end
end

