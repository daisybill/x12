module X12
  class Empty < Base
    def initialize
      super(nil, [])
    end

    def to_s
      ''
    end
  end
end

