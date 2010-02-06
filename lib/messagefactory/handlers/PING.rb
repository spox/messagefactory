# To change this template, choose Tools | Templates
# and open the template in the editor.

module MessageFactory
module Handlers
    class Ping < Handler
        def types_process
            :PING
        end
        # string:: string to process
        # Create a new Ping message
        # OpenStruct will contain:
        # #type #direction #raw #received #server #message
        # :nodoc: PING :not.configured
        # :nodoc: :not.configured PING :test
        def process(string)
            string = string.dup
            m = mk_struct(string)
            begin
                if(string.slice(0).chr == ':')
                    m.server = string.slice!(0, string.index(' '))
                    string.slice!(0)
                    raise 'error' unless string.slice!(0, string.index(' ')).to_sym == :PING
                    string.slice!(0, string.index(':')+1)
                end
            rescue
            end
        end
    end
end
end
