module X12
  module Attributes
    class << self
      def string(node, attribute)
        node.has_attribute?(attribute.to_s) ? node.attributes[attribute.to_s].content : nil
      end

      def boolean(node, attribute)
        value = X12::Attributes.string node, attribute
        return false if value.nil? || value.empty?
        return true if value =~ /(^y(es)?$)|(^t(rue)?$)|(^1$)/i
        return false if value =~ /(^no?$)|(^f(alse)?$)|(^0$)/i
        nil
      end

      def int(node, attribute)
        str = X12::Attributes.string(node, attribute)
        return if str.nil?
        return Float::INFINITY if str == 'inf'
        str.to_i
      end

      def range(node, from, to)
        min = X12::Attributes.int(node, from) || -Float::INFINITY
        max = X12::Attributes.int(node, to)   ||  Float::INFINITY
        if min > max
          raise ArgumentError.new("min attribute can't be greater that max (#{name}: [#{min}, #{max}])")
        end
        Range.new(min, max)
      end
    end
  end
end
