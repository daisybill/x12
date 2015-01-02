module X12
  module Structures
    class Segment < Base

      # Parses this segment out of a string, puts the match into value, returns the rest of the string - nil
      # if cannot parse
      def parse(str)
        s = str
        m = regexp.match(s)

        return nil unless m

        s = m.post_match
        self.parsed_str = m[0]

        @fields = self.to_s.chop.split(Regexp.new(Regexp.escape(field_separator)))
        self.nodes.each_index { |i| self.nodes[i].content = @fields[i+1] }

        s = do_repeats(s)

        return s
      end

      # Render all components of this segment as string suitable for EDI
      def render
        self.to_a.inject(''){|repeat_str, i|
          if i.repeats.begin < 1 and !i.has_content?
            # Skip optional empty segments
            repeat_str
          else
            # Have to render no matter how empty
            repeat_str += i.name+i.nodes.reverse.inject('') do |nodes_str, j|
              field = j.render
              (j.required or nodes_str != '' or field != '') ? field_separator+field+nodes_str : nodes_str
            end + segment_separator
          end
        }
      end

      # Returns a regexp that matches this particular segment
      def regexp
        unless @regexp
          if self.nodes.find{|i| i.type =~ /^".+"$/ }
            # It's a very special regexp if there are constant fields
            re_str = self.nodes.inject("^#{name}#{Regexp.escape(field_separator)}") do |s, i|
              field_re = i.simple_regexp(field_separator, segment_separator)+Regexp.escape(field_separator)+'?'
              field_re = "(#{field_re})?" unless i.required
              s+field_re
            end + Regexp.escape(segment_separator)
            @regexp = Regexp.new(re_str)
          else
            # Simple match
            @regexp = Regexp.new("^#{name}#{Regexp.escape(field_separator)}[^#{Regexp.escape(segment_separator)}]*#{Regexp.escape(segment_separator)}")
          end
        end
        @regexp
      end

      # Finds a field in the segment. Returns EMPTY if not found.
      def find_field(str)
        # If there is such a field to begin with
        field_num = nil
        self.nodes.each_index do |i|
          field_num = i if str == self.nodes[i].name
        end
        return EMPTY if field_num.nil?

        # Parse the segment if not parsed already
        unless @fields
          @fields = self.to_s.chop.split(Regexp.new(Regexp.escape(field_separator)))
          self.nodes.each_index { |i| self.nodes[i].content = @fields[i+1] }
        end
        return self.nodes[field_num]
      end
    end
  end
end
