# To change this template, choose Tools | Templates
# and open the template in the editor.

module MessageFactory
module Handlers
    class Ping < Handler
        def types_process
            :PING
        end
        def process(string)
            string = string.dup
            m = mk_struct(string)
            begin
            rescue
            end
        end
    end
end
end
