module StructuresGenerator
  class << self
    def generate(template, values)
      return if values.nil?
      if values.is_a? Array
        loop = template.create
        values.each { |v|
          loop.repeat { |l| template.children.each { |t| l.children[t.key] = generate(t, v) } }
        }
        loop
      elsif values.is_a? Hash
        n = template.create
        template.children.each { |t| n.children[t.key] = generate(t, values[t.key]) }
        n
      else
        f = template.create
        f.value = values
        f
      end
    end
  end
end
