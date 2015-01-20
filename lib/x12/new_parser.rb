module X12
  class NewParser
    def initialize(template)
      @template = template
    end

    def parse(content)
      document = X12::Document.new content, segment: '~', field: '*' #TODO: use separators method
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
      return unless loop.trigger?(document.current)
      result = loop.create
      begin
        loop.children.each { |child| result.children[child.key] = parse_node child, document }
        result.next unless document.empty?
      end while !document.empty? && loop.trigger?(document.current)
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

    def separators(str)
      raise Exception.new 'It is not a valid X12 document' unless str[0..2] == 'ISA'
      {
        segment: str[105],
        field: str[3],
        composite: str[104]
      }
    end
  end
end
