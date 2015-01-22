module X12
  module Templates
    class Segment < X12::Templates::Base
      options :required?, :range

      def self.parse_options(node)
        {
          required: X12::Attributes.boolean(node, :required),
          range: X12::Attributes.range(node, :min, :max)
        }
      end

      def is_it?(segment)
        if constants?
          segment.name == name && constants_present?(segment)
        else
          segment.name == name
        end
      end

      def constants?
        @children.any? &:const?
      end

      private

      def constants_present?(segment)
        result = true
        @children.each_with_index { |child, index|
          result = false if child.const? && child.const != segment.fields[index]
        }
        result
      end
    end
  end
end
