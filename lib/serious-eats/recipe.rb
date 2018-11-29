require "serious-eats/version"

module SeriousEats
  class Recipe
    attr_accessor :name
    attr_accessor :url
    attr_accessor :category

    attr_accessor :description
    attr_accessor :portion
    attr_accessor :cooking_time
    attr_accessor :prep_time
    attr_accessor :rating
    attr_accessor :ingredients
    attr_accessor :instructions

    @@all = []

    def initialize(name, url, category)
      @name = name
      @url = url
      @category = category
      @@all << self
    end

    def self.all
      @@all
    end
  end
end