module X12
  class Segment
    def initialize(str, separator)
      @fields = str.split separator, -1
    end

    def name
      @fields.first
    end

    def size
      @fields.size
    end

    def field(index)
      @fields[index + 1]
    end
  end
end
