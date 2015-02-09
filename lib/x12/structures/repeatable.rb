module X12
  module Structures
    class Repeatable
      def repeat
        yield self
        @repeats << @children
        @children = @pattern.dup
        nil
      end

      def next
        @repeats << @children
        @children = @pattern.dup
        self
      end

      def each #TODO: implement enumerable interface
        @repeats.each { |r|
          @children = r
          yield self
        }
        nil
      end

      def size
        @repeats.size
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
        @children = @repeats[index]
        block_given? ? yield(object) : object
      end

      protected

      def setter(_, _)
        raise NotImplementedError
      end

      def on_initialize
        @pattern = @children.dup
        @repeats = []
      end
    end
  end
end
