require './db/db_connector.rb'
require './models/item.rb'
require './models/category.rb'

class ItemController
  def show_all_items(params = nil)
    items = Item.get_all_items
    renderer = ERB.new(File.read('./views/items/index.erb'))
    renderer.result(binding)
  end

  def new_item(params = nil)
    categories = Category.get_all_categories
    renderer = ERB.new(File.read('./views/items/create.erb'))
    renderer.result(binding)
  end

  def create_item(params)
    name = params['food-name']
    price = params['food-price']
    description = params['food-desc']
    categories = params['food-categories']
    Item.create_new_item(name, price, description, categories)
  end

  def show_item_details(params)
    item = Item.get_item_detail(params['id'])
    renderer = ERB.new(File.read('./views/items/detail.erb'))
    renderer.result(binding)
  end

  def edit_item(params)
    item = Item.get_item_detail(params['id'])
    categories = Category.get_all_categories
    renderer = ERB.new(File.read('./views/items/edit.erb'))
    renderer.result(binding)
  end

  def update_item(params)
    item = Item.get_item_detail(params['id'])
    categories = Category.get_all_categories
    Item.update_item_detail(item.id, params['food-name'], params['food-price'], params['food-desc'], params['food-categories'])
  end

  def delete_item(params)
    Item.delete_item_by_id(params['id'])
  end
end