module X12
  class Parser
    MS_DEVICES = %w(CON PRN AUX CLOCK$ NUL COM1 LPT1 LPT2 LPT3 COM2 COM3 COM4)

    # Fixes up the file name so we don't worry about DOS files
    def self.sanitized_file_name(name)
      # Deal with Microsoft devices
      base_name = File.basename(name, '.xml')
      if MS_DEVICES.include? base_name
        File.join(File.dirname(name), "#{base_name}_.xml")
      else
        name
      end
    end

    def initialize(file_name)
      save_definition = @x12_definition

      # Read and parse the definition
      sanitized_file_name = X12::Parser.sanitized_file_name(file_name)
      if File.exists?(sanitized_file_name)
        path = sanitized_file_name
      else
        path = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "misc", File.basename(file_name))
      end
      str = File.open(path, 'r').read

      @dir_name = File.dirname(File.expand_path(file_name)) # to look up other files if needed
      @x12_definition = X12::XMLDefinitions.new(str)

      # Populate fields in all segments found in all the loops
      @x12_definition[X12::Loop].each_pair{|k, v|
        process_loop(v)
      } if @x12_definition[X12::Loop]

      # Merge the newly parsed definition into a saved one, if any.
      if save_definition
        @x12_definition.keys.each{|t|
          save_definition[t] ||= {}
          @x12_definition[t].keys.each{|u|
            save_definition[t][u] = @x12_definition[t][u] 
          }
          @x12_definition = save_definition
        }
      end
    end

    # Parse a loop of a given name out of a string. Throws an exception if the loop name is not defined.
    def parse(loop_name, str)
      loop = @x12_definition[X12::Loop][loop_name]
      throw Exception.new("Cannot find a definition for loop #{loop_name}") unless loop
      loop = loop.dup
      loop.parse(str)
      return loop
    end

    # Make an empty loop to be filled out with information
    def factory(loop_name)
      loop = @x12_definition[X12::Loop][loop_name]
      throw Exception.new("Cannot find a definition for loop #{loop_name}") unless loop
      loop = loop.dup
      return loop
    end

    private

    # Recursively scan the loop and instantiate fields' definitions for all its segments
    def process_loop(loop)
      loop.nodes.each do |i|
        case i
          when X12::Loop
            process_loop(i)
          when X12::Segment
            process_segment(i) unless i.nodes.size > 0
          else
            return
        end
      end
    end

    # Instantiate segment's fields as previously defined
    def process_segment(segment)
      unless @x12_definition[X12::Segment] && @x12_definition[X12::Segment][segment.name]
        # Try to find it in a separate file if missing from the @x12_definition structure
        initialize(File.join(@dir_name, segment.name+'.xml'))
        segment_definition = @x12_definition[X12::Segment][segment.name]
        throw Exception.new("Cannot find a definition for segment #{segment.name}") unless segment_definition
      else
        segment_definition = @x12_definition[X12::Segment][segment.name]
      end
      segment_definition.nodes.each_index do |i|
        segment.nodes[i] = segment_definition.nodes[i] 
        # Make sure we have the validation table if any for this field. Try to read one in if missing.
        table = segment.nodes[i].validation
        if table
          unless @x12_definition[X12::Table] && @x12_definition[X12::Table][table]
            initialize(File.join(@dir_name, table+'.xml'))
            throw Exception.new("Cannot find a definition for table #{table}") unless @x12_definition[X12::Table] && @x12_definition[X12::Table][table]
          end
        end
      end
    end
  end
end
