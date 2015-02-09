module X12
  module Templates
    class Field < X12::Templates::Base
      options :range, :required?, :validation?, :const

      def self.parse_options(node)
        {
          range: X12::Attributes.range(node, :min, :max),
          required: X12::Attributes.boolean(node, :required),
          validation: X12::Attributes.boolean(node, :validation),
          const: X12::Attributes.string(node, :const)
        }
      end

      def const?
        !const.nil?
      end
    end
  end
end
