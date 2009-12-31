require File.join(File.dirname(__FILE__), 'test_helper')

class HerbalistTest < Test::Unit::TestCase
  # Herbalist.debug=true
  
  should "parse number of cups" do
    assert_equal 1.cup, Herbalist.parse('1 cup')
    assert_equal 2.cups, Herbalist.parse('2 cups')
    assert_equal 2.5.cups, Herbalist.parse('2.5 cups')
  end
  
  should "parse number of meters" do
    assert_equal 1.meter, Herbalist.parse('1 meter')
    assert_equal 2.meters, Herbalist.parse('2 meters')
    assert_equal 2.5.meters, Herbalist.parse('2.5 meters')
  end
  
  should "parse number of kilometers" do
    assert_equal 1.kilometer, Herbalist.parse('1 kilometer')
    assert_equal 2.kilometers, Herbalist.parse('2 kilometers')
    assert_equal 2.5.kilometers, Herbalist.parse('2.5 kilometers')
  end
  
  should "parse mixed case units" do
    assert_equal 1.kilometer, Herbalist.parse('1 Kilometer')
    assert_equal 2.kilometers, Herbalist.parse('2 KiloMeters')
    assert_equal 2.5.miles, Herbalist.parse('2.5 Miles')
  end
  
  should "ignore units of measure that alchemist does not understand" do
    assert_equal nil, Herbalist.parse('2 awesomes')
  end
  
  
  Alchemist.conversion_table.collect{|k,v| v.keys}.flatten.uniq.each do |unit|
    should "parse #{unit}" do
      assert_equal 1.send(unit).to_f, Herbalist.parse("1 #{unit}").to_f
      assert_equal 2.5.send(unit).to_f, Herbalist.parse("2.5 #{unit}").to_f
    end
  end
end
