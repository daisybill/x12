module X12
  module Templates
    class Field < X12::Templates::Base
      def self.parse_options(node)
        {
          required: X12::Attributes.boolean(node, :required),
          validation: X12::Attributes.boolean(node, :validation)
        }
      end

      def required?
        @options[:required]
      end

      def validation?
        @options[:validation]
      end
    end
  end
end
