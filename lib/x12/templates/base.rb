module X12
  module Templates
    class Base
      CLASSES = {
        'loop' => X12::Templates::Loop,
        'segment' => X12::Templates::Segment,
        'field' => X12::Templates::Field
      }

      class << self
        def from_xml(node)
          attrs = [:name].map{ |attr| extract_from node, attr }
          result = new(*attrs)
          result.children = node.elements.map { |n| CLASSES[node.name].from_xml(node) }
          result
        end

        protected

        def extract_from(node, attribute)
          node.has_attribute?(attribute.to_s) ? node.attributes[attribute.to_s].content : nil
        end
      end

      attr_accessor :children

      def initialize(name)
        @name = name
        @required = node_attribute :required
        @validation = node_attribute :validation
        @children = []
      end

      def create

      end
    end
  end
end
