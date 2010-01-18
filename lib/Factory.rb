module MessageFactory
    class Factory
        # Create a new Factory
        def initialize
            @handers = {}
        end

        # s:: string from server
        # Determine type of message
        def type(s)
            s = s.dup
            t = nil
            begin
                if(s.slice(0,1).chr == ':')
                    s.slice!(0..s.index(' '))
                    t = s.slice!(0..s.index(' ')-1)
                else
                    t = s.slice(0..s.index(' ')-1)
                end
                t.strip!
            rescue
                raise 'Failed to determine message type'
            end
            t
        end

        def process(string)

        end

    end
end