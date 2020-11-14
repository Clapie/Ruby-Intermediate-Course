require './models/item.rb'
require './db/db_connector.rb'

class Item
  def valid?
    return false if @id.nil?
    return false if @name.nil?
    return false if @price.nil? && @price.to_i.to_s != @price
    true
  end
end

describe Item do
  describe 'item.valid?' do
    context "Init valid input" do
      it 'return true' do
        item = Item.new(1, "Nasi Goreng", 25000,"Nasi yang digoreng", categories: ["asin", "gurih"])
        expect(item.valid?).to eq(true)
      end
    end
  end

  describe 'CRUD Item' do
    context "Item Create?" do
      it 'return true' do
        item = Item.create_new_item("Air putih", 10000, "Air putih warna bening")
        item_db = create_db_client.query("select * from items order by item_id desc limit 1").first
        expect(item_db["item_name"]).to eq("Air putih")
        expect(item_db["item_price"]).to eq(10000)
        expect(item_db["item_description"]).to eq("Air putih warna bening")
      end
    end

    context "Item Read?" do
      it 'return true' do
        item_db = create_db_client.query("select * from items order by item_id desc limit 1").first
        max_id = item_db["item_id"]
        item = Item.get_item_detail(max_id)
        expect(item.name).to eq("Air putih")
        expect(item.price).to eq(10000)
        expect(item.description).to eq("Air putih warna bening")
      end
    end

    context "Item Update?" do
      it 'return true' do
        item_db = create_db_client.query("select * from items order by item_id desc limit 1").first
        item = Item.update_item_detail(item_db["item_id"], "f1234%$@Fng", 678345, "Uniqasdhfg!@##^@")
        item_db = create_db_client.query("select * from items order by item_id desc limit 1").first
        expect(item_db["item_name"]).to eq("f1234%$@Fng")
        expect(item_db["item_price"]).to eq(678345)
        expect(item_db["item_description"]).to eq("Uniqasdhfg!@##^@")
      end
    end

    context "Item Delete?" do
      it 'return true' do
        item_db = create_db_client.query("select * from items order by item_id desc limit 1").first
        max_id = item_db["item_id"]
        item = Item.delete_item_by_id(max_id)
        item_db = create_db_client.query("select * from items order by item_id desc limit 1").first
        expect(item_db["item_id"]).not_to eq(max_id)
      end
    end
  end
end
