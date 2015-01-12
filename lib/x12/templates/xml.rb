module X12
  module Templates
    class Xml
      attr_accessor :children
      DEFAULT_DIR = File.join(X12::ROOT, 'misc')
      DEFAULT_EXTENSION = '.xml'

      def initialize(file_path)
        @file_dir = File.dirname(file_path)
        file_name = File.basename(file_path)
        @children = []
        file_name = file_name[0..-5] if File.extname(file_name) == DEFAULT_EXTENSION
        nodes = find_in @file_dir, file_name, 'Loop'
        raise Exception.new("Can't load data from #{file_path}") if nodes.nil?
        parse self, nodes
      end

      private

      CHILDREN_CLASSES = {
        'Loop' => X12::Templates::Loop,
        'Segment' => X12::Templates::Segment,
        'Field' => X12::Templates::Field
      }

      def parse(parent, nodes)
        parent.children = nodes.map do |n|
          child = CHILDREN_CLASSES[n.name].from_xml(n)
          elements = get_elements_for(n)
          parse(child, elements) unless elements.empty?
          child
        end
      end

      def get_elements_for(node)
        return node.elements unless node.elements.empty?
        return [] if node.name == 'Field'
        node_name = X12::Attributes.string(node, :name)
        find_in(@file_dir, node_name, node.name) || find_in(DEFAULT_DIR, node_name, node.name)
      end

      def find_in(dir, node_name, node_type)
        file_path = File.join(dir, "#{node_name}#{DEFAULT_EXTENSION}")
        return nil unless File.exist?(file_path)
        begin
          file = File.open(file_path, 'r')
          root = Nokogiri.XML(file) { |c| c.noblanks }.root
        ensure
          file.close
        end

        return root.children if root.name == node_type

        unless root.name == 'Definition'
          raise Exception.new("Root element must be Definition or #{node_type} (#{file_path}")
        end

        if root.children.count == 1 && root.children.first.name == node_type
          root.children.first.children
        else
          raise Exception.new("Definition must contain only one child #{node_type} (#{file_path})")
        end
      end
    end
  end
end
