require 'nokogiri'

require 'x12/version'
require 'x12/structures/base'
require 'x12/structures/empty'
require 'x12/structures/field'
require 'x12/structures/composite'
require 'x12/structures/segment'
require 'x12/table'
require 'x12/structures/loop'
require 'x12/xmldefinitions'
require 'x12/parser'

module X12
  module Structures
    EMPTY = Empty.new()
    TEST_REPEAT = 100
  end
end
