require 'nokogiri'

require 'x12/version'
require 'x12/attributes'
require 'x12/templates/base'
require 'x12/templates/field'
require 'x12/templates/segment'
require 'x12/templates/loop'
require 'x12/base'
require 'x12/empty'
require 'x12/field'
require 'x12/composite'
require 'x12/segment'
require 'x12/table'
require 'x12/loop'
require 'x12/xmldefinitions'
require 'x12/parser'

module X12
  EMPTY = Empty.new()
  TEST_REPEAT = 100
end
