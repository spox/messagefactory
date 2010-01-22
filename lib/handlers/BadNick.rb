
module MessageFactory
module Handlers
    class BadNick < Handler
        # handlers:: Hash of handlers
        # Create a BadNick handler
        def initialize
        end
        
        # Returns type(s) supported
        def types_process
            :'432'
        end
        # string:: string to process
        # Create a new BadNick message
        # OpenStruct will contain:
        # #type #direction #raw #bad_nick #received
        # :nodoc: ':the.server 432 spox 999 :Erroneous Nickname'
        def process(string)
            m = OpenStruct.new
            string = string.dup
            orig = string.dup
            begin
                string.slice!(0)
                m.server = string.slice!(0, string.index(' '))
                string.slice!(0)
                raise unless string.slice!(0, string.index(' ')).to_sym == :'432'
                2.times{string.slice!(0, string.index(' ')+1)}
                m.bad_nick = string.slice!(0, string.index(' '))
                m.type = :badnick
                m.direction = :incoming
                m.raw = orig
                m.received = Time.now
            rescue
                raise "Failed to parse BadNick string: #{orig}"
            end
            m
        end
    end
end
end
