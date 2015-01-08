module X12
  module Templates
    class Base
      CLASSES = {
        # 'loop' => X12::Templates::Loop,
        # 'segment' => X12::Templates::Segment,
        # 'field' => X12::Templates::Field
      }

      class << self
        def from_xml(node)
          name = extract_from node, :name
          min, max = extract_from(node, :min).to_i, extract_from(node, :max).to_i
          if min > max
            raise ArgumentError.new("min attribute can't be greater that max (#{name}: [#{min}, #{max}])")
          end

          result = new(name, Range.new(min, max), parse_options(node))
          result.children = node.elements.map { |n| CLASSES[n.name.downcase].from_xml(n) }
          result
        end

        protected

        def parse_options(_); {}; end

        def extract_boolean(node, attribute)
          value = extract_from node, attribute
          return false if value.nil? || value.empty?
          return true if value =~ /(^y(es)?$)|(^t(rue)?$)|(^1$)/i
          return false if value =~ /(^no?$)|(^f(alse)?$)|(^0$)/i
          nil
        end

        def extract_from(node, attribute)
          node.has_attribute?(attribute.to_s) ? node.attributes[attribute.to_s].content : nil
        end
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
