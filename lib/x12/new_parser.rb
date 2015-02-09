module X12
  class NewParser
    def initialize(template)
      @template = template
    end

    def parse(content)
      document = X12::Document.new content, separators(content)
      result = X12::Structures::Base.new @template
      @template.children.each { |child| result.add(parse_node child, document) }
      result
    end

    private

    def parse_node(node, document)
      return if document.empty?
      if node.loop?
        parse_loop node, document
      elsif node.segment?
        result = []
        index = 0
        while !document.empty? && node.is_it?(document.current) && index <= node.range.end
          index += 1
          result << parse_segment(node, document.fetch)
        end
        result
      end
    end

    def parse_loop(loop, document)
      return unless loop.trigger?(document.current)
      result = loop.create
      begin
        loop.children.each { |child| result.add(parse_node child, document) }
        result.next
      end while !document.empty? && loop.trigger?(document.current) && result.size < loop.range.end
      result
    end

    def parse_segment(segment, document)
      s = segment.create
      segment.children.each_with_index { |field, index|
        f = field.create
        f.value = document.fields[index]
        s.children << f
      }
      s
    end

    def separators(str)
      if str[0..2] == 'ISA'
        {
          segment: str[105],
          field: str[3],
          composite: str[104]
        }
      else
        {
          segment: '~',
          field: '*',
          composite: ':'
        }
      end
    end
  end
end
