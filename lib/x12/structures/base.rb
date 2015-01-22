module X12
  module Structures
    class Base
      include Enumerable
      attr_reader :template
      attr_accessor :children

      def initialize(template)
        @template = template
        @children = []
        @methods = @template.children.map(&:key).uniq
        on_initialize
      end

      def key
        @template.key
      end

      def to_a
        [self]
      end

      def valid?
        true
      end

      def add(child)
        return if child.nil?
        child.is_a?(Array) ? @children.push(*child.compact) : @children.push(child)
      end

      def method_missing(name, *params, &block)
        key = name[-1] == '=' ? name[0..-2].to_sym : name
        # warn "[DEPRECATION] `##{key}` is deprecated. Please use `#children[#{key.inspect}]` instead"
        super unless @methods.include? key
        key == name ? getter(key, &block) : setter(key, params[0])
      end

      def inspect
        "<#{self.class}: #{self.key}>"
      end

      protected

      def getter(name)
        res = @children.select { |c| c.key == name }
        res = res.first if res.size <= 1
        res = res[0] if res.is_a? X12::Structures::Loop
        block_given? ? yield(res) : res
      end

      def setter(name, value)
        raise NotImplementedError
        # @children[name] = value
      end

      def on_initialize; end
    end
  end
end
