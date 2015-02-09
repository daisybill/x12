module TemplatesGenerator
  DEFAULT_LOOP_OPTIONS = { range: 0..5, required: false }
  DEFAULT_SEGMENT_OPTIONS = { range: 0..1, required: false }
  DEFAULT_FIELD_OPTIONS = { range: 0..100, required: false, validation: false }

  class << self
    def generate(hash)
      generate_from(hash).first
    end

    def loop(name, options = {})
      X12::Templates::Loop.new name, DEFAULT_LOOP_OPTIONS.merge(options)
    end

    def segment(name, options = {})
      X12::Templates::Segment.new name, DEFAULT_SEGMENT_OPTIONS.merge(options)
    end

    def field(name, options = {})
      X12::Templates::Field.new name, DEFAULT_FIELD_OPTIONS.merge(options)
    end

    private

    def generate_from(hash)
      hash.map { |key, value|
        if value.is_a? Array
          s = segment key.to_s
          s.children = value.map { |n| field n.to_s }
          s
        else
          l = loop key.to_s
          l.children = generate_from value
          l
        end
      }
    end
  end
end
