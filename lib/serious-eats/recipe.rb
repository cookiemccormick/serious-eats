module SeriousEats
  class Recipe
    attr_accessor :name
    attr_accessor :url
    attr_accessor :category

    attr_accessor :description
    attr_accessor :portion
    attr_accessor :active_time
    attr_accessor :total_time
    attr_accessor :rating
    attr_accessor :ingredients
    attr_accessor :directions

    @@all = []

    def initialize
      @@all << self
    end

    def self.all
      @@all
    end

    def self.find(id)
      self.all[id - 1]
    end

    def has_data?
      !!description
    end
  end
end