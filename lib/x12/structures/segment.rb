module X12
  module Structures
    class Segment < X12::Structures::Base

      protected

      def getter(name)
        f = @children[name]
        f && f.value
      end

      def setter(name, value)
        f = @children[name] ||= create_field(name)
        f.value = value
      end

      def create_field(name)
        f = @template.children.find { |child| child.key == name }
        raise Exception.new "There are no field named #{name.inspect}" if f.nil?
        f.create
      end
    end
  end
end
