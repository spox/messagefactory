require 'ostruct'

unless(OpenStruct.new.type.nil?)
    class OpenStruct
        def type
            @table[:type]
        end
    end
end

module MessageFactory
module Handlers
    class Handler

        # Returns symbol or array of symbols of allowed message types
        def types_process
            raise NotImplementedError.new
        end

        # data:: string of data
        # Process string and create proper message
        def process(data)
            raise NotImplementedError.new
        end

    end
end
end
