module X12
  class NewParser
    def initialize(template)
      @template = template
    end

    def parse(content)
      document = X12::Document.new content, { segment: '~', field: '*' }
      result = X12::Structures::Base.new @template
      @template.children.each { |child|
        parsed = parse_node child, document
        result.children[child.key] = parsed unless parsed.nil?
      }
      result
    end

    private

    def parse_node(node, document)
      return if document.empty?
      if node.loop?
        parse_loop node, document
      elsif node.segment? && node.name == document.current.name
        parse_segment node, document.fetch
      end
    end

    def parse_loop(loop, document)
      result = loop.create
      begin
        size = document.size
        loop.children.each { |child| result.children[child.key] = parse_node child, document }
        result.next if size != document.size
      end while size != document.size && !document.empty?
      result
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
