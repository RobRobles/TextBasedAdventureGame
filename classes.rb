class Game
  def init
    @player = Player.new
    
    # Create location.
    greenBow = Location.new("Greenbow", "You are stuck in the middle of a zombie infested swamp, lots of fog blur your vision. Watch your step!!.")
    selma = Location.new("Selma", "There is no one around, the slightest noise might attract unwanted attention so tread lightly.")
    columbus = Location.new("Columbus", "The smell of death is in the air, lots of resources here and lots of danger. Its best to get in and out QUICKLY!!!.")
    troy = Location.new("Troy", "A warm dark place that might yeild a great reward but at a great cost, its best to have a weapon handy.")

    # Connect locations.
    greenBow.addBidirectionalExit selma
    greenBow.addBidirectionalExit columbus
    troy.addBidirectionalExit columbus

		#creating items
		lightSaber = Weapon.new("Light Saber", 15) 
		phaserGun = Weapon.new("Phaser Gun", 20)
		spear = Weapon.new("Spear", 10)
		shive = Weapon.new("Shive", 5) 

		#creating food items
		pBurger = Food.new("Pretzel Burger", 25, "no") 
		zBurger = Food.new("Zombie Burger", 15, "no") 
		soda = Food.new("Pepsi", 5, "yes")
		milk = Food.new("Milk", 10, "yes")

		#adding items and food to location 
		greenBow.addWeap lightSaber
		greenBow.addFood soda
		columbus.addWeap phaserGun
		columbus.addFood pBurger 
		selma.addWeap shive
		selma.addFood milk
		troy.addWeap spear
		troy.addFood zBurger  

    # Add NPC enemies and drop them into locations.
    zJ = NPC.new('Zombie Jenny and she looks like she has a key hanging around her neck,')
    troll = NPC.new('Swap Troll')
    ltD = NPC.new('Zombie Lt. Dan and there seems to be a key hanging from his dog tag,')
    zB = NPC.new('Zombie Bubba')
    greenBow.addPerson(ltD)
    troy.addPerson(zB)
    selma.addPerson(zJ)
    columbus.addPerson(troll)

    @currentLocation = selma
    @currentLocation.addPerson(@player)
    @stillPlaying = true
  end


	#look around to see your surroundings 
  def look
    puts "You are in #{@currentLocation.name}."
    puts @currentLocation.desc
    if @currentLocation.hasNPCs?
      puts "You see not to far from you what looks like a #{@currentLocation.getNPCsString}"
    	puts "get too close and you might have to get your hands dirty."
		end
    puts "From here you can go to #{@currentLocation.getExitNames}"
		puts "Food Items: #{@currentLocation.getFoodName} " 
		puts "Items: #{@currentLocation.getItemsName}"  	
	 end

	#view the items that you have 
	def inventory
		puts "Items: #{@player.getItemsName}" 
		puts "Food: #{@player.getFoodName}" 
	end  

	#tells you your descriptions you entered in as well as your current health. 
	def examine 
		puts "Your Description: #{@player.desc}" 
		puts "Health Status: #{@player.health}" 
	end

	#give you a list of commands 
	def help
		puts "Commands: pick up (weapons/items) , move to, drop, examine myself, describe me, look at me, inventory, look"
		puts "Commands: grab (food items), examine food (details about your food), eat (food), drink (beverages)" 
	end 

	#returns the attributes of the food items you have 
	def lookAtFood
		@player.getFoodDesc 
	end 

  def play
    print "Enter your name: "
    @player.name = gets.chomp
		print "Tell me about your self: " 
		@player.desc = gets.chomp 
    puts "Welcome, #{@player.name}!"
		puts "You goal is to find the Golden Feather. The Golden Feather is locked in a giant safe in an undisclosed location." 
		puts "Its in your best interest to explore, be warned not all places provide a warm welcome." 

    look
    while @stillPlaying
      print "Command? "
      cmd = gets.chomp
      if cmd.start_with? "move to "
        locationName = cmd[8..cmd.length]
        nextLocation = @currentLocation.getExitNamed locationName
        if nextLocation
          @currentLocation = nextLocation
          look
        else
          puts "Sorry, I don't see #{locationName} from here."
        end

			#add in pick up conditionals 
			elsif cmd.start_with? "pick up " 
				weaponName = cmd[8..cmd.length]
				newWeapon = @currentLocation.getItemsNamed weaponName
				if newWeapon
					@player.addWeap(newWeapon)
					inventory 
					@currentLocation.removeWeap(newWeapon)
				else  
					puts "I do not see a #{weaponName}" 
				end

			#getting food items 
			elsif cmd.start_with? "grab " 
			foodName = cmd[5..cmd.length]
			newFood = @currentLocation.getFoodNamed foodName
				if newFood
					@player.addFood(newFood)
					inventory 
					@currentLocation.removeFood(newFood)
				else 
					puts "I do not see a #{foodName}" 
				end 

			#add in the drop conditionals 
			elsif cmd.start_with? "drop " 
				weaponDrop = cmd[5..cmd.length]
				weaponToDrop = @player.getItemsNamed weaponDrop
				if weaponToDrop
					puts "You dropped #{weaponDrop}."
					@player.removeWeap(weaponToDrop)
					@currentLocation.addWeap(weaponToDrop)
				else
					puts "You dont have a #{weaponDrop} to drop." 
				end 	

			#drinking and eating
			elsif cmd.start_with? "drink "  
				#getting the name of the drink from the string input
				foodDrink = cmd[6..cmd.length]
				#checking if we actually have that item to drink
				checkDrink = @player.getFoodNamed foodDrink
				#once we know we have it we return a string to see if yes we can drink it or no we cant 
					if @player.food.empty?  
						puts "You have no #{foodDrink} to drink!"
						puts "Its in your best interest to find food"
					else 
						canDrink = checkDrink.getDrink 
						if canDrink == "yes" 
							puts "You just drank #{foodDrink}."
							@player.removeFood(checkDrink)
						else
							puts "#{foodDrink} is not drinkable!" 
						end
					end  

			elsif cmd.start_with? "eat "	
				foodEat = cmd[4..cmd.length]
				#checking is we actually have that item to eat 
				checkFood = @player.getFoodNamed foodEat
				#once we know we have it we need to see if we can acutally eat it
					if @player.food.empty?
						puts "You have no #{foodEat} to eat!"
						puts "Its in your best interest to find food"
					else
						canEat = checkFood.getDrink
						if canEat == "no" 
							puts "You just ate #{foodEat}."
							player.removeFood(checkFood)
						else 
							puts "#{foodEat} is not edible!" 
						end
					end  
				 
			#adding in the look to look at your surroundings, inventory to look at what you have and examine to look at your description
			#and help command 
			elsif cmd == "examine myself" || cmd == "look at me" || cmd == "describe me"  
				examine
			elsif cmd == "examine food" 
				lookAtFood  
			elsif cmd == "help" 
				help
      elsif cmd == "look"
        look
			elsif cmd == "inventory" 
				inventory 
      else
        puts "Sorry, you can't do that."
      end
    end
    
  end
end

class Person
  attr_accessor :health, :items, :location, :name, :desc, :food  

  def initialize(name="Ye Olde Person")
    @health = 100
    @items = []
		@desc = []
		@food = [] 
    @name = name
    @location = nil
		@desc = desc 
  end

	def addWeap(aWeapon)
		@items << aWeapon
	end 
	
	def removeWeap(aWeapon)
		@items.delete(aWeapon)
	end 

	def addFood(food)
		@food << food
	end 

	def removeFood(food)
		@food.delete(food)
	end 

	def getItemsName
		return @items.map { |item| item.name }.join(", ") 
	end

	def getDrink
		return @food.map {|food| food.drink} 
	end  

	def hasFood
		if @food.empty?
			puts "You have no food items to consume"
			puts "Its in your best interest to find food, and soon!" 
		end 
	end 

	def getFoodDesc
		if @food.empty?
			puts "No food to examine"
		else 
			puts @food.map { |food| 'Food: ' + food.name + ' HP: ' + food.health.to_s}
		end 
	end 

	def getFoodName
		if @food.empty? 
			return "You have no food" 
		else 
			return @food.map { |food| food.name }.join(", ") 
		end
	end  

	def getFoodNamed(aFood)
		return @food.find { |loc| loc.name == aFood} 
	end 

	def getItemsNamed(weaponNamed)
		return @items.find { |loc| loc.name == weaponNamed}
	end

  def attack(thing, object)
  end
end

class Player < Person
end

class NPC < Person
end

class Location
  attr_reader :name, :desc

  def initialize(name, desc)
    @name = name
    @desc = desc
    @items = []
		@food = []
    @people = []
    @exits = []
  end

  def getExitNames
    return @exits.map { |loc| loc.name }.join(", ")
  end

  def getItemsName
    if @items.empty?
      return "There are no items here."
    else
      return @items.map { |item| item.name }.join(", ")
    end
  end

	def getFoodName 
		if @food.empty? 
			return ""
		else 
			return @food.map { |food| food.name }.join(", ")
		end 
	end 

	def getFoodNamed(aFood)
		return @food.find { |loc| loc.name == aFood } 
	end 

	def getItemsNamed(locationNamed)
		return @items.find { |loc| loc.name == locationNamed} 
	end 

  def addExit(aLocation)
    @exits << aLocation
  end

  def addBidirectionalExit(aLocation)
    addExit(aLocation)
    aLocation.addExit(self)
  end

  def addPerson(person)
    @people << person
    person.location = self
  end

	def addWeap(aWeapon)
		@items << aWeapon
	end

	def removeWeap(aWeapon)
		@items.delete(aWeapon)
	end 

	def addFood(food)
		@food << food
	end 
	
	def removeFood(food)
		@food.delete(food)
	end 

  def getExitNamed(locationName)
    return @exits.find { |loc| loc.name == locationName }
  end

  def hasNPCs?
    not @people.find_all { |person| person.class == NPC }.empty?
  end

  def getNPCsString
    return @people.find_all { |person| person.class == NPC }.
                   map      { |person| person.name }.
                   join(", ")
  end

end

class Weapon
	attr_accessor :name, :hitPoints
	
	def initialize(name, hitPoints)
		@name = name
		@hp = hitPoints 
	end 

end

class Food
	attr_accessor :name, :health, :drink 

	def initialize(name, health, drink)
		@name = name
		@health = health 
		@drink = drink
	end 

	def getHealth
		@health
	end 
		
	def getDrink
		@drink
	end 

end





