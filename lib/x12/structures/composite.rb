module X12
  module Structures
    class Composite < Base
      def inspect
        "Composite "+super.inspect
      end

      def parse(_)
        raise NotImplementedError.new('X12::Structures::Composite#parse(content) method not implemented')
      end
    end
  end
end
