module MessageFactory
module Handlers
    class Invite < Handler
        # Returns type(s) supported
        def types_process
            :INVITE
        end
        # string:: string to process
        # Create a new BadNick message
        # OpenStruct will contain:
        # #type #direction #raw #received #source #target #channel
        # :nodoc: ':the.server 432 spox 999 :Erroneous Nickname'
        def process(string)
            
        end
    end
end
end
