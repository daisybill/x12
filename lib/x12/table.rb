module X12
  class Table < Hash
    attr_reader :name

    def initialize(name, name_values)
      @name = name
      self.merge!(name_values)
    end

    def inspect
      "Table #{name} -- #{super.inspect}"
    end
  end
end

