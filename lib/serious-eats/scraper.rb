module SeriousEats
  class Scraper
    def get_index_page
      Nokogiri::HTML(open("https://www.seriouseats.com/the-food-lab/recipes"))
    end

    def get_recipes
      self.get_index_page.css("#recipes .module")
    end

    def make_recipes
      self.get_recipes.map do |block|
        recipe = Recipe.new
        recipe.name = block.css("h4.title").text.strip
        recipe.category = block.css("a.category-link").text.strip
        recipe.url = block.css("a.module__link").attribute("href").value
        recipe
      end
    end

    def get_show_page(recipe)
      Nokogiri::HTML(open(recipe.url))
    end

    def get_attributes(recipe)
      self.get_show_page(recipe).css("div.recipe-body")
    end

    def make_attributes(recipe)
      self.get_attributes(recipe).map do |block|
        recipe.description = block.css(".recipe-introduction-body p:not(.caption)").text.strip
        recipe.portion = block.css("span.info.yield").text.strip
        recipe.active_time = block.css("ul.recipe-about li:nth-child(2) span.info").text.strip
        recipe.total_time = block.css("ul.recipe-about li:nth-child(3) span.info").text.strip
        recipe.rating = block.css("span.info.rating-value").text.strip

        recipe.ingredients = block.css("li.ingredient").map do |ingredient|
          text = ingredient.text.strip

          if ingredient.css("strong").any?
            text = "\n#{text.underline}"
          end

          text
        end

        recipe.directions = block.css(".recipe-procedure-text").map do |procedure|
          procedure.text.strip
        end
      end
    end
  end
end