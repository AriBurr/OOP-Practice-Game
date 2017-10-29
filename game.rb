class Scene

  def enter()
    puts "This scene is not yet configured. Subclass it and implement enter()."
    exit(1)
  end

end

class Engine

  def initialize(scene_map)
    @scene_map = scene_map
  end

  def play()
    current_scene = @scene_map.opening_scene()
    last_scene = @scene_map.next_scene('finished')

    while current_scene != last_scene
      next_scene_name = current_scene.enter()
      current_scene = @scene_map.next_scene(next_scene_name)
    end

    # be sure to print out the last scene
    current_scene.enter()
  end

end

class Character
    def initialize(name, health, attack, defence, money)
        @name = name
        @health = health
        @attack_pwr = attack
        @defence = defence # .10 will Reduces damage by 10%
        @money = money
    end

    def do_damage(damage)
      @health -= damage
    end

    def attack (target)
        damage = ((1 - @defence) * rand(1..5)).floor
        target.do_damage(damage)
    end

    def give_money(money)
      @money += money
    end

    def get_money(target)
      money = @money
      target.give_money(money)
    end

    def dead?
      @health <= 0
    end

    def inventory
      puts "Gold: #{@money}"
    end

    def buy_item(item)
      if item === "bread"
        @money -= 10
        @health += 5
      elsif item === "elixer"
        @money -= 250
        @health = 100
      end
      puts "Your health is now #{@health}"
    end

    def money_status
      return @money
    end


    def battle_stats
      puts "#{@name}'s current stats:"
      puts "-----------------"
      puts "Health: #{@health}"
      puts "Attack Power: #{@attack_pwr}"
      puts "Defence: #{@defence}"
      puts "-----------------"
    end
end


class BattleSystem
  def initialize(player, enemy)
    puts "You are battling the enemy"
    player.battle_stats()
    enemy.battle_stats()

    until player.dead? || enemy.dead?

      puts "Press enter to attack!"
      action = gets.chomp
      if action == ""
        puts "You swing your #{$weapon}!"
      else
        puts "You can't do that!"
      end
      #Player attacks enemy
      player.attack(enemy)
      enemy.battle_stats()
      puts "The enemy lunges at you!"
      enemy.attack(player)
      player.battle_stats()
    end
    puts "You have defeated the enemy!"
    puts "Enemy has dropped some loot, Do you pick it up: yes or no?"
    pick_up = gets.chomp
    if(pick_up == "yes")
      enemy.get_money(player)
      player.inventory
    else
      puts "You walk away."
    end


  end

end

class Death < Scene
  def enter()
    puts "You died!"
    exit(1)
  end
end

class Open < Scene

  def enter()
    puts "You, there! What is your name?"
    name = gets.chomp
    $main_character = Character.new(name, 100, 10, 0.1, 10)
    puts "You stand at the edge of the dark Forest of Nilborg."
    puts "You reach into your pocket and pull out"
    puts "#{$main_character.inventory}"
    puts "Arising from the blackest depths of the forst you see the gnarled,"
    puts "spiralling towers of the Unholy Castle."
    puts "This is where you are going."
    puts "What weapon do you hold?"
    $weapon = gets.chomp
    puts "With your #{$weapon} in hand, you enter the forest."
    puts "May the gods have mercy on your soul."
    puts "--------------------"
    return "forest"
  end

end

class Forest < Scene

  def enter()
    puts "The forest echoes with screams of desecration. You see dark, "
    puts "shrouded figures darting amongst the dead oaks."
    puts "You know you must fight your way out."
    puts "Prepare for battle!"
    goblin = Character.new("Gordo the Goblin", 50, 10, 0.1, (rand(10..25)))
    forest_battle = BattleSystem.new($main_character, goblin)
    if $main_character.dead?
      return "death"
    end
    return "trade_wagon"

  end

end

class TradeInventory

  def initialize()
    @bread = 5
    @elixer = 1
  end

  def purchased(item)

    if item == "bread"
      if $main_character.money_status >=5
        @bread -= 1
        $main_character.buy_item(item)
      else
        puts "You dont have enough gold"
      end
      puts "I have no more" if @bread <= 0
      puts "----------"
    elsif item =="elixer"
      if $main_character.money_status >= 250
        $main_character.buy_item(item)
        @elixer -= 1
      else
        puts "You dont have enough gold"
      end
        puts "I have no more" if @elixer <= 0
        puts "----------"
    else
      puts "I don't have any of that."
    end

  end

  def currentInventory()

    puts @bread > 0 ? "Bread: #{@bread}" : "There is no more!"
    puts @elixer > 0 ? "Elixer: #{@elixer}" : "There is no more!"

  end

end

class TradeWagon < Scene

  def enter()
    puts "Covered in the blood of your slain enemies, you stagger onwards"
    puts "to the center of this damned forest."
    puts "As you approach the castle walls, you see a small cart parked"
    puts "outside the main gate where a haggard merchant plies his wares, "
    puts "an assortment of rusty weapons and stale crusts of bread."
    puts "The merchant sweeps aside his robe to show you a foul exotic health "
    puts "elixer he has brewed."

    inventory = TradeInventory.new()

    puts "What would you like to buy?"
    puts "Bread will replenish 5 of your health and costs 10g, max 5."
    puts "The health elixer replenishes 100% of your health and costs 250g."

    item = gets.chomp

    while item != "exit"

      inventory.purchased(item);

      inventory.currentInventory();

      puts "Would you like to buy anything else? Press exit to leave."
      item = gets.chomp

    end

    puts "The merchant thanks you and turns to organize his cart. A gold shilling"
    puts "falls from his robes and lands on the ground next to you."
    puts "What do you do? \n 1) take the shilling \n 2) leave the shilling"

    action = gets.chomp

    if action.include? "take"
      puts "You slowly reach down to grab the shilling while the merchant's back"
      puts "is turned. The merchant reacts!"
      merchant = Character.new("Merchant", 100, 10, 0.1, 100)
      merchant_battle = BattleSystem.new($main_character, merchant)
        if $main_character.dead?
          return "death"
        else
          puts "You dust yourself off and put the shilling in your pocket."
          return "castle"
        end
    else
      puts "You leave the shilling where it lies and turn towards the castle."
      return "castle"
    end

  end

end

class Castle < Scene
  def enter()
    puts "You see a castle!"
    return "finished"
  end
end

class Finished < Scene
  def enter()
    puts "You won! Good job!"
  end
end

class Map

  @@scenes = {
    "open" => Open.new(),
    "forest" => Forest.new(),
    "trade_wagon" => TradeWagon.new(),
    "castle" => Castle.new(),
    "death" => Death.new(),
    "finished" => Finished.new()
  }

  def initialize(start_scene)
    @start_scene = start_scene
  end

  def next_scene(scene_name)
    val = @@scenes[scene_name]
    return val
  end

  def opening_scene()
    return next_scene(@start_scene)
  end

end

  a_map = Map.new("open")
  a_game = Engine.new(a_map)
  a_game.play()
