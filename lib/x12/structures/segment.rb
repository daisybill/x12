module X12
  module Structures
    class Segement < X12::Structures::Base
      protected

      def on_initialize
        @fields = []
      end
    end
  end
end