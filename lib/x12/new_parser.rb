module X12
  class NewParser
    def initialize(template)
      @template = template
    end

    def parse(file_name)
      document = X12::Document.new file_name, {}
      @template.children.each { |child| parse_node child, document }
    end

    private

    def parse_node(node, document)
      return if document.empty?
      if node.loop?
        parse_loop node, document
      elsif node.segment? && node.name == document.current.name
        parse_segment node, document.fetch
      else
        node.children.each { |child| parse_node child, document }
      end
    end

    def parse_loop(loop, document)
      begin
        size = document.size
        loop.children.each { |child| parse_node child, document }
      end while size != document.size && !document.empty?
    end

    def parse_segment(segment, document)
      s = segment.create
      segment.children.each_with_index { |field, index|
        f = field.create
        f.value = document.fields[index]
        s.children[field.key] = f
      }
      s
    end
  end
end
