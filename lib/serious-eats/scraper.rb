module SeriousEats
  class Scraper
    INDEX_URL = "https://www.seriouseats.com/the-food-lab/recipes"

    def parse_url(url)
      Nokogiri::HTML(open(url))
    end

    def get_recipes
      parse_url(INDEX_URL).css("#recipes .module")
    end

    def get_recipe_data(recipe)
      parse_url(recipe.url).css("div.recipe-body")
    end

    def fetch_recipes
      get_recipes.map do |block|
        recipe = Recipe.new
        recipe.name = block.css("h4.title").text.strip
        recipe.category = block.css("a.category-link").text.strip
        recipe.url = block.css("a.module__link").attribute("href").value
        recipe
      end
    end

    def fetch_recipe_data(recipe)
      get_recipe_data(recipe).map do |block|
        recipe.description = block.css(".recipe-introduction-body p:not(.caption)").map do |description|
          description.text.strip
        end.select do |description|
          # some recipes have some empty <p> tags that need to be filtered out
          description.length > 0
        end

        recipe.portion = block.css("span.info.yield").text.strip
        recipe.active_time = block.css("ul.recipe-about li:nth-child(2) span.info").text.strip
        recipe.total_time = block.css("ul.recipe-about li:nth-child(3) span.info").text.strip
        recipe.rating = block.css("span.info.rating-value").text.strip.to_f.round(1)

        recipe.ingredients = block.css("li.ingredient").map do |ingredient|
          text = ingredient.text.strip

          if ingredient.css("strong").any?
            text = "\n#{text.underline}"
          end

          text
        end

        recipe.directions = block.css(".recipe-procedure-text").map do |direction|
          direction.text.strip
        end
      end
    end
  end
end