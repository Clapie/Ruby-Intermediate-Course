require './db/db_connector.rb'
require './models/item.rb'
require './controllers/item_controller.rb'

class Item
  def self.find_by_name(name)
    client = create_db_client
    rawItem = client.query("select * from items where item_name = '#{name}'").first
    item = Item.new(rawItem["item_id"], rawItem["item_name"], rawItem["item_price"], rawItem["item_description"])
    item
  end
end


describe ItemController do
  describe 'create new item' do
    it 'save item' do
      controller = ItemController.new
      params = {
        'food-name' => "Nasi Goreng",
        'food-price' => 25000,
        'food-desc' => "Nasi yang digoreng",
        'food-categories' => [1]
      }

      response = controller.create_item(params)
      expected_item = Item.find_by_name("Nasi Goreng")
      expect(expected_item).not_to be_nil
    end
  end
end
