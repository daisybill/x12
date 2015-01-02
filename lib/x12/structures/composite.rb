module X12
  module Structures
    class Composite < Base
      def inspect
        "Composite "+super.inspect
      end
    end
  end
end
