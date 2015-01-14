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

      protected

      def on_initialize
        @loop = @children.dup
        @loops = []
      end
    end
  end
end
