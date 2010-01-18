# To change this template, choose Tools | Templates
# and open the template in the editor.

module MessageFactory
    class Bounce < Handler
        # handlers:: Hash of handlers
        # Create a new bounce handler
        def initialize(handlers)
            handlers['005'] = self
        end

        # string:: String to be processed
        # Create a new bounce message
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
