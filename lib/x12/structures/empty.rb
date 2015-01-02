module X12
  module Structures
    class Empty < Base
      def initialize
        super(nil, [])
      end

      def to_s
        ''
      end
    end
  end
end
