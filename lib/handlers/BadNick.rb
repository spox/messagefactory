require 'messagefactory/Handler'

module MessageFactory
    class BadNick < Handler
        # handlers:: Hash of handlers
        # Create a BadNick handler
        def initialize(handlers)
            handlers[] = self
            handlers['432'] = self
        end
        # string:: string to process
        # Create a new BadNick message
        def process(string)
            m = nil
            if(string =~ /432\s\S+\s(\S+)\s:/)
                m = OpenStruct.new
                m.type = :badnick
                m.direction = :incoming
                m.bad_nick = $1
                m.raw = string
                m.received = Time.now
            else
                raise "Failed to parse BadNick string: #{string}"
            end
            m
        end
    end
end
