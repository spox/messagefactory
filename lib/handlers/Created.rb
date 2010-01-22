require 'time'

module MessageFactory
module Handlers
    class Created < Handler

        # Returns type(s) supported
        def types_process
            :'003'
        end

        # string:: string to process
        # Create a new Created message
        # OpenStruct will contain:
        # #type #direction #raw #received #created
        # :nodoc: :not.configured 003 spox :This server was created Tue Mar 24 2009 at 15:42:36 PDT'
        def process(string)
            string = string.dup
            m = nil
            begin
                orig = string.dup
                string.downcase!
                m = OpenStruct.new
                string.slice!(0, string.index(' ')+1)
                raise 'Bad message type' unless string.slice!(0, string.index(' '))
                string.slice!(0, string.index('d')+2)
                time = Time.parse(string)
                m.type = :created
                m.direction = :incoming
                m.received = Time.now
                m.raw = orig.dup
                m.created = time
            rescue
                raise "Failed to parse Created message: #{orig}"
            end
            m
        end
    end
end
end
