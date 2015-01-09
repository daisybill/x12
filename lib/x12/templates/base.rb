module X12
  module Templates
    class Base
      class << self
        def from_xml(node)
          name = X12::Attributes.string node, :name
          new name, parse_options(node)
        end

        protected

        def options(*opts)
          opts.each do |name|
            key = name
            key = key.to_s[0..-2].to_sym if key.to_s.include? '?'
            define_method name do
              @options[key]
            end
          end
        end

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
