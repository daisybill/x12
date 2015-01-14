module X12
  module Structures
    class Base
      include Enumerable
      attr_reader :template, :children

      def initialize(template)
        @template = template
        @children = {}
        @template.children.each { |child| @children[child.name.to_sym] = nil }
        on_initialize
      end

      def valid?; end

      def method_missing(name, *params)
        key = name[-1] == '=' ? name.to_s[0..-2].to_sym : name
        warn "[DEPRECATION] `##{key}` is deprecated. Please use `#children[#{key.inspect}]` instead"
        super unless @children.key? key
        key == name ? getter(key) : setter(key, params[0])
      end

      protected

      def getter(name)
        @children[name]
      end

      def setter(name, value)
        @children[name] = value
      end

      def on_initialize; end
    end
  end
end
