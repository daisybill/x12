module X12
  class Document
    attr_reader :current

    def initialize(content, separators)
      @separators = separators
      @segments = content.split(separators[:segment])
      @current = first_segment
    end

    def fetch
      raise "Can't fetch next segment, document is empty" if empty?
      result = @current
      @segments.shift
      @current = empty? ? nil : first_segment
      result
    end

    def next
      raise "Can't fetch next segment, document is empty" if empty?
      @segments.shift
      @current = empty? ? nil : first_segment
    end

    def size
      @segments.size
    end

    def empty?
      @segments.size == 0
    end

    private

    def first_segment
      X12::NewSegment.new @segments.first, @separators[:field]
    end
  end
end