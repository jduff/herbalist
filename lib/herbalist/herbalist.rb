module Herbalist
  # collect up all the possible unit types that Alchemist can handle
  POSSIBLE_UNITS = Alchemist.library.categories.map{|c| Alchemist.library.unit_names c}.flatten.uniq
  MULTIWORD_UNITS = POSSIBLE_UNITS.collect{|u| u.to_s}.grep(/_/)
  
  class << self
    def parse(text)
      text = text.dup
      puts "TEXT: #{text}" if Herbalist.debug
      @tokens = self.tokenize(text).select { |token| token.tagged? }
      puts "TOKENS: #{@tokens}" if Herbalist.debug
      
      return nil unless @tokens.length>1
      
      # at the moment all we handle is a number followed by a unit
      last_number = nil
      result = nil
      @tokens.each do |token|
        if last_number && (unit=token.get_tag(:unit))
          result = last_number.send(unit.value)
          break
        elsif (num=token.get_tag(:number))
          last_number = num.value
        end
      end
      
      return result
    end
    
    def tokenize(text)
      # cleanup the string before tokenizing
      text = normalize(text)
      @tokens = text.split(' ').collect { |word| Token.new(word) }
      @tokens = Tag.scan(@tokens)
    end
    
    private
    def normalize(text)
      # use Numerizer to convert any numbers in words to digets in the string
      text = Numerizer.numerize(text)
      puts "NUMERIZED: #{text}" if Herbalist.debug
      
      text = evaluate_fractions(text)
      puts "FRACTIONED: #{text}" if Herbalist.debug
      
      text = normalize_multiword(text)
      puts "MULTIWORDED: #{text}" if Herbalist.debug
      return text
    end
    
    # takes fractions in the string (1/4) and converts them to floats (0.25)
    def evaluate_fractions(text)
      text.gsub(/(\d+)\/(\d+)/) { ($1.to_f/$2.to_f).to_s }
    end
    
    def normalize_multiword(text)
      MULTIWORD_UNITS.each do |unit|
        text = text.gsub(/#{unit.split('_').join(' ')}/i, unit)
      end
      text
    end
  end
  
  # based on the Token class found in Chronic
  class Token
     attr_accessor :word, :tags

    def initialize(word)
      @word = word
      @tags = []
    end

    # Tag this token with the specified tag
    def tag(new_tag)
      @tags << new_tag
    end

    # Remove all tags of the given class
    def untag(tag_type)
      @tags = @tags.select { |m| m.type!=tag_type }
    end

    # Return true if this token has any tags
    def tagged?
      @tags.size > 0
    end

    # Return the Tag that matches the given class
    def get_tag(tag_type)
      matches = @tags.select { |m| m.type==tag_type }
      return matches.first
    end

    # Print this Token in a pretty way
    def to_s
      "#{@word}(#{@tags.join(', ')})"
    end
  end
  
  
  class Tag
    attr_accessor :value, :type

		def initialize(type, value)
		  @type = type
			@value = value
		end
		
		# scan the given tokens and tag any matches
		def self.scan(tokens)
		  tokens.each do |token|
		    if t = self.scan_for_numbers(token) then token.tag(t) end
		    if t = self.scan_for_units(token) then token.tag(t) end
	    end
		  tokens
	  end
	  
	  # check the token to see if if it is a number
	  # then tag it
	  def self.scan_for_numbers(token)
	    if token.word =~ /(^|\W)(\d*\.\d+)($|\W)/ || token.word =~ /(^|\W)(\d+)($|\W)/
	      return Tag.new(:number, $2.to_f)
      end
      return nil
    end
    
    # check the token and see if it is a type of unit that Alchemist can handle
    # then tag the token with that unit type
    def self.scan_for_units(token)
      return nil if token.get_tag(:number)
      # all units
      POSSIBLE_UNITS.each do |unit| 
        if token.word.length<=2 # special matching for short forms ex. Mi
          return Tag.new(:unit, unit) if token.word == unit.to_s
        elsif token.word =~ /(^|\W)#{unit.to_s}($|\W)/i
          return Tag.new(:unit, unit)
        end
      end
      
      # try si units with prefixes (kilo, deca etc)
      Alchemist.library.unit_prefixes.each do |prefix, value|
        if token.word =~ /^#{prefix.to_s}.+/i
          Alchemist.library.si_units.each do |unit|
            if unit.to_s=~/#{token.word.gsub(/^#{prefix.to_s}/i,'')}$/i
              return Tag.new(:unit, "#{prefix}#{unit}") 
            end
          end
        end
      end

      return nil
    end
    
    def to_s
      "#{type}-#{value}"
    end
  end

end
