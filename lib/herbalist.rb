require 'numerizer'
require 'alchemist'

require 'herbalist/herbalist'

unless Alchemist.method_defined?(:si_units)
  module Alchemist
    def self.si_units
      @@si_units
    end
  end
end

module Herbalist
  class << self
    attr_accessor :debug
  end
  
  self.debug = false
end