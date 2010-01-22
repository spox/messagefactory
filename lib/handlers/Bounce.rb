module MessageFactory
module Handlers
    class Bounce < Handler

        # Returns type(s) supported
        def types_process
            :'005'
        end

        # string:: string to process
        # Create a new BadNick message
        # OpenStruct will contain:
        # #type #direction #raw #received #server #port
        # :nodoc: ':the.server 432 spox 999 :Erroneous Nickname'
        def process(string)
            m = nil
            begin
                orig = string.dup
                2.times{string.slice!(0..string.index(' '))}
                server = string.slice!(0..string.index(',')-1)
                string.slice!(0..string.index(' ',4))
                m = OpenStruct.new
                m.type = :bounce
                m.direction = :incoming
                m.received = Time.now
                m.raw = orig
                m.server = server
                m.port = string
            rescue Object => boom
                raise "Failed to parse Bounce string: #{orig}"
            end
            m
        end
    end
end
end
