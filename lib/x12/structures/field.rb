module X12
  module Structures
    class Field < X12::Structures::Base
      attr_accessor :value

      def to_s
        value.to_s
      end

      protected

      def on_initialize
        @value = nil
      end
    end
  end
end
