module X12
  ROOT = File.expand_path('../..', __FILE__)
  # EMPTY = Empty.new()
  TEST_REPEAT = 100
end

require 'nokogiri'

require 'x12/version'
require 'x12/attributes'
require 'x12/structures/base'
require 'x12/structures/field'
require 'x12/structures/segment'
require 'x12/structures/loop'
require 'x12/templates/base'
require 'x12/templates/field'
require 'x12/templates/segment'
require 'x12/templates/loop'
require 'x12/templates/xml'
require 'x12/document'
require 'x12/new_segment'
require 'x12/new_parser'
require 'x12/base'
require 'x12/empty'
require 'x12/field'
require 'x12/composite'
require 'x12/segment'
require 'x12/table'
require 'x12/loop'
require 'x12/xmldefinitions'
require 'x12/parser'

# module X12
#   ROOT = File.expand_path('../..', __FILE__)
#   EMPTY = Empty.new()
#   TEST_REPEAT = 100
# end
