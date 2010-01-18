require 'ostruct'

module MessageFactory
    class Handler

        # handlers:: Hash of handlers
        # Create a new handler and add self to list of
        # available handlers
        def initialize(handlers={})
            raise NotImplementedError.new
        end

        # data:: string of data
        # Process string and create proper message
        def process(data)
            raise NotImplementedError.new
        end

        # data:: string of data
        # Preprocess allows for actions to be taken while
        # message handling is still in a synchronized state
        def preprocess(data)
        end

        # Does this handler need to be synchronized
        def sync?
            false
        end
    end
end
