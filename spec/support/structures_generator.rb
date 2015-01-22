module StructuresGenerator
  class << self
    def generate(template, values)
      return if values.nil?
      if values.is_a?(Array)
        return nil if values.empty?
        loop = template.create
        values.each { |v|
          loop.repeat { |l| l.add template.children.map { |t| generate(t, v[t.key]) } }
        }
        loop
      elsif values.is_a? Hash
        n = template.create
        n.add template.children.map { |t| generate(t, values[t.key]) }
        n
      else
        f = template.create
        f.value = values
        f
      end
    end
  end
end
