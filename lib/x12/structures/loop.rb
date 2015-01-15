module X12
  module Structures
    class Loop < X12::Structures::Base
      def repeat
        yield self
        @loops << @children
        @children = @loop.dup
      end

      def each
        @loops.each { |loop|
          @children = loop
          yield self
        }
      end

      def size
        @loops.size
      end

      def empty?
        size == 0
      end

      def has_content?
        warn '[DEPRECATION] `#has_content?` deprecated, use `#empty` instead'
        !empty?
      end

      def [](index)
        object = index < size ? self : nil
        @children = @loops[index]
        block_given? ? yield(object) : object
      end

      protected

      def setter(_, _)
        raise NotImplementedError.new('Direct setters for loop not allowed')
      end

      def on_initialize
        @loop = @children.dup
        @loops = []
      end
    end
  end
end
