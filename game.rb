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
    def initialize(name)
        @name = name
        @health = 100
        @attack_pwr = 10
        @defence = 0.10 #Reduces damage by 10%
        @money = 100
    end

   def attack
        damage = @health / @attack_pwr
        @health -= ((1 - @defence) * damage * rand(1..3))
    end

    def battle_stats
      puts "#{@name}'s current stats:"
      puts "-----------------"
      puts "Health: #{@health}"
      puts "Attack Power: #{@attack_pwr}"
      puts "Defence: #{@defence}"
      puts "-----------------"
    end

    def char_name
      puts @name
    end

    def health
      return @health
    end


end

class BattleSystem
  def initialize()
    puts "You are battling!"
    $main_character.battle_stats()
    goblin = Character.new("Goblin")
    goblin.battle_stats()

    while($main_character.health > 1)
      puts "Press Enter to attack!"
      action = gets.chomp

      if action == ""
        puts "You swing your #{$weapon}!"
      else
        puts "You can't do that!"
      end

      goblin.attack
      goblin.battle_stats()
      puts "The goblin lunges at you!"
      $main_character.attack
      $main_character.battle_stats()

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
    $main_character = Character.new(name)
    puts "You stand at the edge of the dark Forest of Nilborg."
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
    forest_battle = BattleSystem.new
    return "trade_wagon"
  end
end

class TradeWagon < Scene
  def enter()
    puts "Covered in the blood of your slain enemies, you stagger onwards"
    puts "to the center of this damned forest."
    puts "As you approach the castle walls, you see a small cart parked"
    puts "outside of the main gate."
    return "castle"
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
