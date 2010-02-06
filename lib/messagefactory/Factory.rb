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
            t.to_sym
        end

        # string:: String from IRC server to process
        # Process the given string and return parsed
        # message or nil
        def process(string, do_require=true)
            s = nil
            mtype = type(string)
            if(@handlers[mtype])
                s = @handlers.process(string)
            else
                if(do_require)
                    require "messagefactory/handlers/#{mtype}"
                    s = process(string, false)
                else
                    raise NoMethodError.new("No handler found to process string: #{string}")
                end
            end
            s
        end

    end
end