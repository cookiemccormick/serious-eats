module SeriousEats
  class CLI
    def call
      puts ""
      puts "Hello there! Welcome to the Serious Eats Recipes!".colorize(:green).bold

      @scraper = SeriousEats::Scraper.new
      recipes = @scraper.make_recipes

      start
    end

    def start
      puts ""
      puts "Please choose a number for the recipe you would like to view: 1-24.".bold
      puts ""

      display_recipes
      puts ""

      input = gets.strip.to_i
      if input >= 1 && input <= 24
        recipe = SeriousEats::Recipe.find(input)
        @scraper.make_attributes(recipe)
        print_recipe(recipe)
        puts ""
        puts "Would you like to see another recipe? Please enter Y or N.".bold
        puts ""
        input = gets.strip.downcase

        if input == "y"
         puts ""
         start
        elsif input == "n"
         puts ""
          puts "Thank you! Goodbye!".bold
          puts ""
        else
          puts ""
          puts "PLEASE ENTER A VALID RESPONSE.".colorize(:red).blink
          start
        end

      else
        puts ""
        puts "PLEASE ENTER A VALID RESPONSE.".colorize(:red).blink
        start
      end
    end

    def display_recipes
      SeriousEats::Recipe.all.each_with_index do |recipe, index|
        puts "#{index + 1}. #{recipe.name}"
      end
    end

    def print_recipe(recipe)
      puts ""
      puts "#{recipe.name.upcase} - #{recipe.category.upcase}".colorize(:green).bold
      puts ""
      puts "Description:".bold
      puts "#{recipe.description}"
      puts ""
      puts "Portion:".bold
      puts "#{recipe.portion}"
      puts ""
      puts "Active Cooking Time:".bold
      puts "#{recipe.active_time}"
      puts ""
      puts "Total Time:".bold
      puts "#{recipe.total_time}"
      puts ""

      if recipe.rating == ""
        puts "Rating: N/A".bold
      else
        puts "Rating out of 5:".bold
        puts "#{recipe.rating}"
      end

      puts ""
      puts "Ingredients:".bold
      recipe.ingredients.each do |ingredient|
        puts "#{ingredient}"
      end

      puts ""
      puts "Directions:".bold
      recipe.directions.each_with_index do |direction, index|
        puts "#{index + 1}. #{direction}"
      end

      puts ""
      puts "Website:".bold
      puts "#{recipe.url}"
    end
  end
end