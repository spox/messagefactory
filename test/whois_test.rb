# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'messagefactory/Handler'
require 'messagefactory/handlers/311'

class WhoisTest < Test::Unit::TestCase
  def setup
    @handler = MessageFactory::Handlers::Whois.new
  end
  def test_types
    [:'311', :'319', :'312', :'307', :'330', :'317', :'318'].each do |t|
      assert(@handler.types_process.include?(t))
    end
  end

  def test_freenode_style
    s = [':wolfe.freenode.net 311 spox spox ~spox pool-96-225-201-176.ptldor.dsl-w.verizon.net * :spox']
    s << ':wolfe.freenode.net 319 spox spox :##c++ ##C #rubygems #jruby #ruby-lang #ruby @#mod_spox'
    s << ':wolfe.freenode.net 312 spox spox wolfe.freenode.net :Manchester, England'
    s << ':wolfe.freenode.net 378 spox spox :is connecting from *@pool-96-225-201-176.ptldor.dsl-w.verizon.net 96.225.201.176'
    s << ':wolfe.freenode.net 317 spox spox 258126 1265393193 :seconds idle, signon time'
    s << ':wolfe.freenode.net 330 spox spox spox :is logged in as'
    s << ':wolfe.freenode.net 318 spox spox :End of /WHOIS list.'
    m = nil
    s.each do |l|
      if(l == s.last)
        m = @handler.process(l)
      else
        assert_nil(@handler.process(l))
      end
    end
    assert_kind_of(OpenStruct, m)
    assert_kind_of(Time, m.received)
    assert_equal(:incoming, m.direction)
    assert_equal(:whois, m.type)
    assert_equal(s.size, m.raw.size)
    s.size.times{|i| assert_equal(s[i], m.raw[i])}
    assert_equal('wolfe.freenode.net', m.source)
    assert_equal('spox', m.target)
    assert_equal('~spox', m.username)
    assert_equal('pool-96-225-201-176.ptldor.dsl-w.verizon.net', m.host)
    assert_equal('spox', m.real_name)
    %w(##c++ ##C #rubygems #jruby #ruby-lang #ruby #mod_spox).each do |c|
      assert(m.channels.include?(c))
    end
    assert_equal(1, m.ops.size)
    assert(m.ops.include?('#mod_spox'))
    assert_nil(m.voice)
    assert_equal(258126, m.idle)
    assert_equal(1265393193, m.signon)
    assert_equal(:identified, m.nickserv)
    assert_equal('wolfe.freenode.net', m.irc_host)
  end

  def test_dal_style
    s = [':swiftco.wa.us.dal.net 311 spox spox ~spox pool-96-225-201-176.ptldor.dsl-w.verizon.net * :spox']
    s << ':swiftco.wa.us.dal.net 319 spox spox :+#php #ruby #mysql @#mod_spox'
    s << ':swiftco.wa.us.dal.net 312 spox spox swiftco.wa.us.dal.net :www.swiftco.net - Swift Communications'
    s << ':swiftco.wa.us.dal.net 307 spox spox :has identified for this nick'
    s << ':swiftco.wa.us.dal.net 317 spox spox 529 1265393189 :seconds idle, signon time'
    s << ':swiftco.wa.us.dal.net 318 spox spox :End of /WHOIS list.'
    m = nil
    s.each do |l|
      if(l == s.last)
        m = @handler.process(l)
      else
        assert_nil(@handler.process(l))
      end
    end
    assert_kind_of(OpenStruct, m)
    assert_kind_of(Time, m.received)
    assert_equal(:incoming, m.direction)
    assert_equal(:whois, m.type)
    assert_equal(s.size, m.raw.size)
    s.size.times{|i| assert_equal(s[i], m.raw[i])}
    assert_equal('swiftco.wa.us.dal.net', m.source)
    assert_equal('spox', m.target)
    assert_equal('~spox', m.username)
    assert_equal('pool-96-225-201-176.ptldor.dsl-w.verizon.net', m.host)
    assert_equal('spox', m.real_name)
    %w(#php #ruby #mysql #mod_spox).each do |c|
      assert(m.channels.include?(c))
    end
    assert_equal(4, m.channels.size)
    assert_equal(1, m.voice.size)
    assert_equal(1, m.ops.size)
    assert(m.voice.include?('#php'))
    assert(m.ops.include?('#mod_spox'))
    assert_equal(529, m.idle)
    assert_equal(1265393189, m.signon)
    assert_equal(:identified, m.nickserv)
    assert_equal('swiftco.wa.us.dal.net', m.irc_host)
  end

  def test_bad
    assert_raise(RuntimeError) do
      @handler.process('bad string')
    end
  end
end