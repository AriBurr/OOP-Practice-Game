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
    def initialize(name, health, attack, defence)
        @name = name
        @health = health
        @attack_pwr = attack
        @defence = defence # .10 will Reduces damage by 10%
        @money = 100
    end

    def do_damage(damage)
      @health -= damage
    end

    def attack (target)
        damage = ((1 - @defence) * rand(1..5)).floor
        target.do_damage(damage)
    end

    def dead?
      @health <= 0
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
    $main_character = Character.new(name, 5, 10, 0.1)
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
    goblin = Character.new("Gordo the Goblin", 5100, 10, 0.1)
    forest_battle = BattleSystem.new($main_character, goblin)
    if $main_character.dead?
      return "death"
    end
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
