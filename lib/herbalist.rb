require 'numerizer'
require 'alchemist'

require 'herbalist/herbalist'

# reopen Alchemist and create an accessor for si_units
# hopefully a future patch will mean we can remove this
unless Alchemist.respond_to?(:si_units)
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