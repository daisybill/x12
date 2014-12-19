module X12
  class Loop < Base
    # Parse a string and fill out internal structures with the pieces of it. Returns 
    # an unparsed portion of the string or the original string if nothing was parsed out.
    def parse(document)
      working = document

      all_matched = true
      nodes.each do |node|
        matched = node.parse(working)
        if matched
          working = matched
        else
          all_matched = false unless node.repeats.begin == 0
        end
        working = matched if matched
      end

      return nil if document == working
      return document if all_matched == false

      self.parsed_str = document[0..-working.length-1]
      working = do_repeats(working)
    end

    def do_repeats(document)
      if self.repeats.end > 1
        possible_repeat = self.dup
        p_s = possible_repeat.parse(document)
        if p_s && p_s != document
          document = p_s
          self.next_repeat = possible_repeat
        end
      end
      document
    end

    # Render all components of this loop as string suitable for EDI
    def render
      if self.has_content?
        self.to_a.inject('') do |loop_str, i|
          loop_str += i.nodes.inject('') do |nodes_str, j|
            nodes_str += j.render
          end
        end
      else
        ''
      end
    end
  end
end

