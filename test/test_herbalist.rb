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
  
  should "parse numbers in words" do
    assert_equal 1.kilometer, Herbalist.parse('one Kilometer')
    assert_equal 15.kilometers, Herbalist.parse('fifteen Kilometers')
    assert_equal 21.5.miles, Herbalist.parse('twenty-one and a half Miles')
  end
  
  should "parse fractions in words" do
    assert_equal 0.25.cup, Herbalist.parse('a quarter cup')
    assert_equal 0.5.teaspoon, Herbalist.parse('a half teaspoon')
    assert_equal 1.25.liters, Herbalist.parse('one and a quarter liters')
  end
  
  should "parse multiword units" do
    assert_equal 1.cubic_meter, Herbalist.parse('one Cubic Meter')
    assert_equal 15.kilowatt_hours, Herbalist.parse('fifteen kilowatt Hours')
    assert_equal 21.5.tropical_years, Herbalist.parse('21.5 tropical years')
  end
  
  should "parse units from within a string of other text" do
    assert_equal 1.cup, Herbalist.parse("1 Cup onion chopped")
    assert_equal 1.25.ounces, Herbalist.parse("1 Package (1.25 ounces) taco seasoning mix")
    assert_equal 16.ounces, Herbalist.parse("1 Can (16 ounces) tomatoes, undrained")
    assert_equal 6.cups, Herbalist.parse("and 6 Cups turkey broth")
    
    assert_equal 2.5.football_fields, Herbalist.parse("it was two and a half football fields")
    assert_equal 15.meters, Herbalist.parse("John ran 15 meters")
  end
  
  should "not match can to ccandela units" do
    assert_equal nil, Herbalist.parse("1 Can")
  end
  
  should "ignore units of measure that alchemist does not understand" do
    assert_equal nil, Herbalist.parse('2 awesomes')
  end
  
  # add tests for all units Alchemist can handle
  Alchemist.conversion_table.collect{|k,v| v.keys}.flatten.uniq.each do |unit|
    should "parse #{unit}" do
      assert_equal 1.send(unit), Herbalist.parse("1 #{unit}")
      assert_equal 2.5.send(unit), Herbalist.parse("2.5 #{unit}")
    end
    
    # tests for all multi word units
    if (words = unit.to_s.split('_')).length > 1
      should "parse multiword unit '#{words.join(' ')}'" do
        assert_equal 1.send(unit), Herbalist.parse("1 #{words.join(' ')}")
        assert_equal 2.5.send(unit), Herbalist.parse("2.5 #{words.join(' ')}")
      end
    end
  end
end
