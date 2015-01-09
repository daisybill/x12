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
    end
  end
end
