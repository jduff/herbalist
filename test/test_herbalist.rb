require File.join(File.dirname(__FILE__), 'test_helper')

class HerbalistTest < Test::Unit::TestCase
  # Herbalist.debug=true
  
  should "parse number of cups" do
    assert_equal :cup, Herbalist.parse('1 cup').unit_name
    assert_equal 1.cup.value, Herbalist.parse('1 cup').value
    assert_equal 2.cups.value, Herbalist.parse('2 cups').value
    assert_equal 2.5.cups.value, Herbalist.parse('2.5 cups').value
  end
  
  should "parse number of meter" do
    assert_equal :meter, Herbalist.parse('1 meter').unit_name
    assert_equal 1.meter.value, Herbalist.parse('1 meter').value
    assert_equal 2.meter.value, Herbalist.parse('2 meter').value
    assert_equal 2.5.meter.value, Herbalist.parse('2.5 meter').value
  end
  
  should "parse number of kilometer" do
    assert_equal :meter, Herbalist.parse('1 kilometer').unit_name
    assert_equal 1000, Herbalist.parse('1 kilometer').exponent
    assert_equal 1.kilometer.value, Herbalist.parse('1 kilometer').value
    assert_equal 2.kilometer.value, Herbalist.parse('2 kilometer').value
    assert_equal 2.5.kilometer.value, Herbalist.parse('2.5 kilometer').value
  end
  
  should "parse mixed case units" do
    assert_equal 1.kilometer.value, Herbalist.parse('1 Kilometer').value
    assert_equal 2.kilometer.value, Herbalist.parse('2 KiloMeters').value
    assert_equal 2.5.miles.value, Herbalist.parse('2.5 Miles').value
  end
  
  should "parse numbers in words" do
    assert_equal 1.kilometer.value, Herbalist.parse('one Kilometer').value
    assert_equal 15.kilometer.value, Herbalist.parse('fifteen Kilometer').value
    assert_equal 21.5.miles.value, Herbalist.parse('twenty-one and a half Miles').value
  end
  
  should "parse fractions in words" do
    assert_equal 0.25.cup.value, Herbalist.parse('a quarter cup').value
    assert_equal 0.5.teaspoon.value, Herbalist.parse('a half teaspoon').value
    assert_equal 1.25.liters.value, Herbalist.parse('one and a quarter liters').value
  end
  
  should "parse multiword units" do
    assert_equal 1.cubic_meter.value, Herbalist.parse('one Cubic Meter').value
    assert_equal 15.kilowatt_hours.value, Herbalist.parse('fifteen kilowatt Hours').value
    assert_equal 21.5.tropical_years.value, Herbalist.parse('21.5 tropical years').value
  end
  
  should "parse units from within a string of other text" do
    assert_equal 1.cup.value, Herbalist.parse("1 Cup onion chopped").value
    assert_equal 1.25.ounces.value, Herbalist.parse("1 Package (1.25 ounces) taco seasoning mix").value
    assert_equal 16.ounces.value, Herbalist.parse("1 Can (16 ounces) tomatoes, undrained").value
    assert_equal 6.cups.value, Herbalist.parse("and 6 Cups turkey broth").value
    
    assert_equal 2.5.football_fields.value, Herbalist.parse("it was two and a half football fields").value
    assert_equal 15.meter.value, Herbalist.parse("John ran 15 meter").value
  end
  
  should "not match can to ccandela units" do
    assert_equal nil, Herbalist.parse("1 Can")
  end
  
  should "ignore units of measure that alchemist does not understand" do
    assert_equal nil, Herbalist.parse('2 awesomes')
  end
  
  # add tests for all units Alchemist can handle
  Alchemist.library.categories.map{|c| Alchemist.library.unit_names(c)}.flatten.uniq.each do |unit|
    should "parse #{unit}" do
      assert_equal 1.send(unit).value, Herbalist.parse("1 #{unit}").value
      assert_equal 2.5.send(unit).value, Herbalist.parse("2.5 #{unit}").value
    end
    
    # tests for all multi word units
    if (words = unit.to_s.split('_')).length > 1
      should "parse multiword unit '#{words.join(' ')}'" do
        assert_equal 1.send(unit).value, Herbalist.parse("1 #{words.join(' ')}").value
        assert_equal 2.5.send(unit).value, Herbalist.parse("2.5 #{words.join(' ')}").value
      end
    end
  end
end
