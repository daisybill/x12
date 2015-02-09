module X12
  module Templates
    class Loop < X12::Templates::Base
      options :required?, :range

      def self.parse_options(node)
        {
          required: X12::Attributes.boolean(node, :required),
          range: X12::Attributes.range(node, :min, :max)
        }
      end

      def trigger?(segment)
        children.first.is_it? segment
      end
    end
  end
end
