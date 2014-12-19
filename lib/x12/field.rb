module X12
  class Field
    attr_reader :name, :type, :required, :min_length, :max_length, :validation
    attr_writer :content

    def initialize(name, type, required, min_length, max_length, validation)
      @name       = name
      @type       = type
      @required   = required
      @min_length = min_length.to_i
      @max_length = max_length.to_i
      @validation = validation
      @content = nil
    end

    def inspect
      "Field #{name}|#{type}|#{required}|#{min_length}-#{max_length}|#{validation} <#{@content}>"
    end

    def to_s
      render
    end

    def render
      unless @content
        @content = $1 if self.type =~ /"(.*)"/ # If it's a constant
      end
      @content || ''
    end

    def has_content?
      !@content.nil? && ('"'+@content+'"' != self.type)
    end

    def set_empty!
      @content = nil
    end

    # Returns simplified string regexp for this field, takes field separator and segment separator as arguments
    def simple_regexp(field_sep, segment_sep)
      case self.type
      when /"(.*)"/
        $1
      else
        "[^#{Regexp.escape(field_sep)}#{Regexp.escape(segment_sep)}]*"
      end
    end

    # Returns proper validating string regexp for this field, takes field separator and segment separator as arguments
    # This... never gets called
    def proper_regexp(field_sep, segment_sep)
      case self.type
      when 'I'
        "\\d{#{@min_length},#{@max_length}}"
      when 'S'
        "[^#{Regexp.escape(field_sep)}#{Regexp.escape(segment_sep)}]{#{@min_length},#{@max_length}}"
      when /C.*/
        "[^#{Regexp.escape(field_sep)}#{Regexp.escape(segment_sep)}]{#{@min_length},#{@max_length}}"
      when /"(.*)"/
        $1
      else
        "[^#{Regexp.escape(field_sep)}#{Regexp.escape(segment_sep)}]*"
      end
    end
  end
end

