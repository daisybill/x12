module X12
  class NewSegment
    attr_reader :name, :fields

    def initialize(str, separator = '*')
      @fields = str.split separator, -1
      @name = @fields.shift
      raise Exception.new("Name can't be blank") if name.nil? || name.empty?
    end

    def size
      @fields.size
    end
  end
end
