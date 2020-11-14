require './db/db_connector.rb'

class Item
  attr_accessor :id, :name, :price, :categories, :description

  def initialize(id, name)
    @name = name
    @id = id
  end

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

  def self.get_all_items(search="")
    client = create_db_client
    if search == ""
      rawItems = client.query("select * from items")
    else
      rawItems = client.query("select * from items where item_name like '%#{search}%';")
    end

    items = Array.new
    rawItems.each do |item|
      categories = Category.get_item_categories(item["item_id"])
      items.push(Item.new(item["item_id"], item["item_name"], item["item_price"], item["item_description"], categories))
    end
    items
  end

  def self.create_new_item(name, price, description, categories)
    client = create_db_client
    client.query("insert into items (item_name, item_price, item_description) values ('#{name}', '#{price}', '#{description}')")
    rawItem_id = client.query("select max(item_id) item_id from items").first
    item_id = rawItem_id["item_id"]

    unless categories.nil?
      categories.each do |category|
        item_category_id = client.query("select * from categories where categories.category_id = '#{category}'")
        client.query("insert into item_categories (item_id, category_id) values ('#{item_id}', '#{category}')")
      end
    end
  end

  def self.get_item_detail(id)
    client = create_db_client
    rawItem = client.query("select * from items where item_id = '#{id}'").first
    itemCategories = Category.get_item_categories(id)

    item = Item.new(rawItem["item_id"], rawItem["item_name"], rawItem["item_price"], rawItem["item_description"], itemCategories)
    item
  end

  def self.update_item_detail(id, name, price, description, categories)
    client = create_db_client
    client.query("update items set item_name='#{name}', item_price='#{price}', item_description='#{description}' where item_id = '#{id}'")
    client.query("delete from item_categories where item_id = '#{id}'")

    categories.each do |category_id|
      client.query("insert into item_categories (item_id, category_id) values ('#{id}', '#{category_id}')")
    end
  end

  def self.delete_item_by_id(id)
    client = create_db_client
    client.query("delete from item_categories where item_id = '#{id}'")
    client.query("delete from items where item_id = '#{id}'")
  end
end
