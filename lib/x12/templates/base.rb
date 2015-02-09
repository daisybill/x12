module X12
  module Templates
    class Base
      class << self
        def from_xml(node) #TODO: mustn't be dependent on xml
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

        def parse_options(_); {}; end #TODO: implement as macro

        def inherited(base)
          base.class_eval do
            type = base.name.split('::').last
            define_method :type do
              type
            end

            structure_class = X12::Structures.const_get(type)
            define_method :structure_class do
              structure_class
            end
          end
        end
      end

      attr_reader :name
      attr_accessor :children

      def initialize(name, options)
        @name = name
        @options = options
        @children = []
      end

      def key
        @key ||= name.to_sym
      end

      def create
        structure_class.new(self)
      end

      def loop?
        type == 'Loop'
      end

      def segment?
        type == 'Segment'
      end

      def field?
        type == 'Field'
      end

      def type
        'Base'
      end

      def structure_class
        X12::Structures::Base
      end

      def inspect
        result = "#{self.class}: #{self.key}"
        result << " (#{@children.map(&:name).join(', ')})" unless field?
        "<#{result}>"
      end
    end
  end
end
