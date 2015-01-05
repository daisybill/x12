module X12
  module Structures
    class Base
      attr_reader :template

      def initialize(template)
        @template = template
        on_initialize
      end

      def valid?; end

      protected

      def on_initialize; end
    end
  end
end
