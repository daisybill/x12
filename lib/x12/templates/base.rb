module X12
  module Templates
    class Base
      class << self
        def from_xml(node)
          name = X12::Attributes.string node, :name
          range = X12::Attributes.range node, :min, :max

          result = new(name, range, parse_options(node))
          result.children = node.elements.map { |n| const_get(n.name).from_xml(n) }
          result
        end

        protected

        def parse_options(_); {}; end
      end

      attr_reader :name
      attr_reader :range
      attr_reader :validation
      attr_accessor :children

      def initialize(name, range, options)
        @name = name
        @range = range
        @options = options
        @validation = false
        @children = []
      end

      def create

      end
    end
  end
end
