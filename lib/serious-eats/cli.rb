module SeriousEats
  class CLI
    def call
      puts ""
      puts "Hello there! Welcome to the Serious Eats Recipes!".colorize(:green).bold

      @scraper = SeriousEats::Scraper.new
      @scraper.fetch_recipes

      start
    end

    def start
      puts ""
      puts "Please choose a number for the recipe you would like to view: 1-24.".bold
      puts ""

      display_recipes
      puts ""

      input = gets.strip.to_i

      if input >= 1 && input <= Recipe.all.count
        recipe = SeriousEats::Recipe.find(input)

        if !recipe.has_data?
          @scraper.fetch_recipe_data(recipe)
        end

        print_recipe(recipe)

        puts ""
        puts "Would you like to see another recipe? Please enter Y or N.".bold
        puts ""

        input = gets.strip.downcase

        if input == "y"
          puts ""
          start
        elsif input == "n"
          goodbye_message
        else
          invalid_message
        end

      else
        invalid_message
      end

    end

    def invalid_message
      puts ""
      puts "PLEASE ENTER A VALID RESPONSE.".colorize(:red).blink
      start
    end

    def goodbye_message
      puts ""
      puts "Thank you! Goodbye!".bold
      puts ""
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
      puts recipe.description.join("\n\n")

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

      if recipe.rating == 0
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