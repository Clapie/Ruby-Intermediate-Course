class Item
  attr_accessor :id, :name, :price, :categories, :description

  def initialize(id, name, price, description, categories = nil)
    @name = name
    @price = price
    @id = id
    @description = description
    @categories = categories
  end

  def print_categories_name
    categories_name = Array.new
    @categories.each do |category|
      categories_name.push(category.name)
    end
    categories_name.join(", ")
  end

  def category_included?(category_id)
    categories_id = Array.new
    @categories.each do |category|
      categories_id.push(category.id)
    end

    categories_id.include?(category_id)
  end
end