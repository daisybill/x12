module X12
  module Templates
    class Base
      class << self
        def from_xml(node)
          name = X12::Attributes.string node, :name
          new name, parse_options(node)
        end

        protected

        def parse_options(_); {}; end
      end

      attr_reader :name
      attr_accessor :children

      def initialize(name, options)
        @name = name
        @options = options
        @children = []
      end

      def create

      end
    end
  end
end
