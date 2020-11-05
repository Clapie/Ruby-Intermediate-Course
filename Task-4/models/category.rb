class Category
  attr_accessor :id, :name, :items

  def initialize(id, name, items = nil)
    @id = id
    @name = name
    @items = items
  end

  def self.get_all_categories
    client = create_db_client
    rawCategories = client.query("select * from categories")

    categories = Array.new
    rawCategories.each do |category|
      items = get_category_items(category["category_id"])
      categories.push(Category.new(category["category_id"], category["category_name"], items))
    end
    categories
  end

  def self.create_new_category(name)
    client = create_db_client
    client.query("insert into categories (category_name) values ('#{name}')")
  end

  def self.get_category_detail(id)
    client = create_db_client
    rawCategory = client.query("select * from categories where category_id = '#{id}'").first
    categoryItems = get_category_items(id)
    category = Category.new(rawCategory["category_id"], rawCategory["category_name"], categoryItems)
    category
  end

  def self.update_category_detail(id, name)
    client = create_db_client
    client.query("update categories set category_name='#{name}' where category_id = '#{id}'")
  end

  def self.delete_category_by_id(id)
    client = create_db_client
    client.query("delete from item_categories where category_id = '#{id}'")
    client.query("delete from categories where category_id = '#{id}'")
  end

  def self.get_category_items(id)
    client = create_db_client
    rawItems = client.query("select i.item_name from item_categories ic
                                                inner join items i
                                                inner join categories c
                                                on i.item_id = ic.item_id
                                                and c.category_id = ic.category_id
                                                and c.category_id = '#{id}'")

    items = Array.new
    rawItems.each do |item|
      items.push(item["item_name"])
    end
    items
  end
end