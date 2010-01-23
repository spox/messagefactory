
module MessageFactory
module Handlers
    class LuserChannels < Handler
        def types_process
            :'254'
        end
        # string:: string to process
        # Create a new LuserChannels message
        # OpenStruct will contain:
        # #type #direction #raw #received #server #target #num_channels #message
        # :nodoc: :crichton.freenode.net 254 spox 24466 :channels formed
        def process(string)
            string = string.dup
            orig = string.dup
            begin
                
            end
        end
    end
end
end