module X12
  module Templates
    class Segment < X12::Templates::Base
      options :required?

      def self.parse_options(node)
        {
          required: X12::Attributes.boolean(node, :required)
        }
      end
    end
  end
end
