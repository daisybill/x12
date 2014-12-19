module X12
  class XMLDefinitions < Hash

    def initialize(str)
      doc = Nokogiri.XML(str)
      definitions = doc.root.name =~ /^Definition$/i ? doc.root.elements.to_a : [doc.root]
      definitions.each { |element|
        syntax_element = case element.name
                         when /table/i
                           parse_table(element)
                         when /segment/i
                           parse_segment(element)
                         when /composite/i
                           parse_composite(element)
                         when /loop/i
                           parse_loop(element)
                         end

        self[syntax_element.class] ||= {}
        self[syntax_element.class][syntax_element.name]=syntax_element
      }
    end

    private

    def parse_boolean(s)
      return case s
             when nil
               false
             when ""
               false
             when /(^y(es)?$)|(^t(rue)?$)|(^1$)/i
               true
             when /(^no?$)|(^f(alse)?$)|(^0$)/i
               false
             else
               nil
             end
    end

    def parse_type(s)
      return case s
             when nil
               'string'
             when /^C.+$/
               s
             when /^i(nt(eger)?)?$/i
               'int'
             when /^l(ong)?$/i
               'long'
             when /^d(ouble)?$/i
               'double'
             when /^s(tr(ing)?)?$/i
               'string'
             else
               nil
             end
    end

    def parse_int(s)
      return case s
             when nil
               0
             when /^\d+$/
               s.to_i
             when /^inf(inite)?$/
               999999
             else
               nil
             end
    end

    def parse_attributes(e)
      throw Exception.new("No name attribute found for : #{e.inspect}")          unless name = e.attributes["name"].content
      min = parse_int(e.attributes.has_key?("min") ? e.attributes["min"].content : nil )
      throw Exception.new("Cannot parse attribute 'min' for: #{e.inspect}") unless min

      max = parse_int(e.attributes.has_key?("max") ? e.attributes["max"].content : nil )
      throw Exception.new("Cannot parse attribute 'max' for: #{e.inspect}") unless max

      type = parse_type(e.attributes.has_key?("type") ? e.attributes["type"].content : nil )
      throw Exception.new("Cannot parse attribute 'type' for: #{e.inspect}") unless type

      required = parse_boolean(e.attributes.has_key?("required") ? e.attributes["required"].content : nil )
      throw Exception.new("Cannot parse attribute 'required' for: #{e.inspect}") if required.nil?

      validation = parse_boolean(e.attributes.has_key?("validation") ? e.attributes["validation"].content : nil )

      min = 1 if required and min < 1
      max = 999999 if max == 0

      return name, min, max, type, required, validation
    end

    def parse_field(e)
      name, min, max, type, required, validation = parse_attributes(e)

      # FIXME - for compatibility with d12 - constants are stored in attribute 'type' and are enclosed in
      # double quotes
      const_field =  e.attributes["const"]
      if(const_field)
        type = "\"#{const_field.content}\""
      end

      Field.new(name, type, required, min, max, validation)
    end

    def parse_table(e)
      name, min, max, type, required, validation = parse_attributes(e)

      content = e.search("Entry").inject({}) do |t, entry|
        t[entry.attributes["name"].content] = entry.attributes["value"].content
        t
      end
      Table.new(name, content)
    end

    def parse_segment(e)
      name, min, max, type, required, validation = parse_attributes(e)

      fields = e.search("Field").inject([]) do |f, field|
        f << parse_field(field)
      end
      Segment.new(name, fields, Range.new(min, max))
    end

    def parse_composite(e)
      name, min, max, type, required, validation = parse_attributes(e)

      fields = e.search("Field").inject([]) do |f, field|
        f << parse_field(field)
      end
      Composite.new(name, fields)
    end

    def parse_loop(e)
      name, min, max, type, required, validation = parse_attributes(e)

      components = e.elements.to_a.inject([]) do |r, element|
        r << case element.name
             when /loop/i
               parse_loop(element)
             when /segment/i
               parse_segment(element)
             else
               throw Exception.new("Cannot recognize syntax for: #{element.inspect} in loop #{e.inspect}")
             end
      end
      Loop.new(name, components, Range.new(min, max))
    end
  end
end

