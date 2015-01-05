module X12
  module Structures
    class Loop < Base
      attr_reader :loops

      def parse(document)
        @loops = []
        begin
          size = document.size
          nodes.each { |node| node.parse(document) }
          @loops += 1
        end until size == document.size || document.empty? || @loops >= repeats.end
      end

      # Render all components of this loop as string suitable for EDI
      def render
        if self.has_content?
          self.to_a.inject('') do |loop_str, i|
            loop_str << i.nodes.inject('') do |nodes_str, j|
              nodes_str << j.render
            end
          end
        else
          ''
        end
      end
    end
  end
end
