require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'herbalist'

class Test::Unit::TestCase

  def self.test(name, &block)
    define_method("test_#{name.gsub(/\s+/,'_')}".to_sym, &block)
  end
end
