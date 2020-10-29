require 'mysql2'
require './model/item'
require './model/category'

def create_db_client
  client = Mysql2::Client.new(
    :host => '127.0.0.1',
    :username => 'Clapie',
    :password => 'Password98!',
    :database => 'food_oms_db'
  )
  client
end

def get_item_categories(id)
  client = create_db_client
  rawCategories = client.query("select * from item_categories ic
                                inner join items i
                                inner join categories c
                                on i.item_id = ic.item_id
                                and c.category_id = ic.category_id
                                and i.item_id = '#{id}'")

  categories = Array.new
  rawCategories.each do |category|
    categories.push(Category.new(category["category_id"], category["category_name"]))
  end
  categories
end

def get_all_items
  client = create_db_client
  rawItems = client.query("select * from items")

  items = Array.new
  rawItems.each do |item|
    categories = get_item_categories(item["item_id"])
    items.push(Item.new(item["item_id"], item["item_name"], item["item_price"], item["item_description"], categories))
  end
  items
end

def get_all_categories
  client = create_db_client
  rawCategories = client.query("select * from categories")

  categories = Array.new
  rawCategories.each do |category|
    categories.push(Category.new(category["category_id"], category["category_name"]))
  end
  categories
end

def create_new_item(name, price, description, categories)
  client = create_db_client
  client.query("insert into items (item_name, item_price, item_description) values ('#{name}', '#{price}', '#{description}')")
  rawItem_id = client.query("select max(item_id) item_id from items").first
  item_id = rawItem_id["item_id"]

  unless categories.empty?
    categories.each do |category|
      item_category_id = client.query("select * from categories where categories.category_id = '#{category}'")
      client.query("insert into item_categories (item_id, category_id) values ('#{item_id}', '#{category}')")
    end
  end
end

def get_item_detail(id)
  client = create_db_client
  rawItem = client.query("select * from items where item_id = '#{id}'").first
  itemCategories = get_item_categories(id)

  item = Item.new(rawItem["item_id"], rawItem["item_name"], rawItem["item_price"], rawItem["item_description"], itemCategories)
  item
end

def update_item_detail(id, name, price, description, categories)
  client = create_db_client
  client.query("update items set item_name='#{name}', item_price='#{price}', item_description='#{description}' where item_id = '#{id}'")
  client.query("delete from item_categories where item_id = '#{id}'")

  categories.each do |category_id|
    client.query("insert into item_categories (item_id, category_id) values ('#{id}', '#{category_id}')")
  end
end

def delete_item(id)
  client = create_db_client
  client.query("delete from item_categories where item_id = '#{id}'")
  client.query("delete from items where item_id = '#{id}'")
end
