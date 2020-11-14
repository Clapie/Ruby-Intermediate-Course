require './models/category.rb'
require './db/db_connector.rb'

class Category
  def valid?
    return false if @id.nil?
    return false if @name.nil?
    true
  end
end

def select_last_category
  create_db_client.query("select * from categories order by category_id desc limit 1").first
end

describe Category do
  describe 'category.valid?' do
    context "Init valid input" do
      it 'return true' do
        category = Category.new(1, "TESTING")
        expect(category.valid?).to eq(true)
      end
    end
  end

  describe 'CRUD Category' do
    context "Category Create?" do
      it 'return true' do
        category = Category.create_new_category("TESTING")
        category_db = select_last_category
        expect(category_db["category_name"]).to eq("TESTING")
      end
    end

    context "Category Read?" do
      it 'return true' do
        category_db = select_last_category
        max_id = category_db["category_id"]
        category = Category.get_category_detail(max_id)
        expect(category.name).to eq("TESTING")
      end
    end

    context "Category Update?" do
      it 'return true' do
        category_db = select_last_category
        category = Category.update_category_detail(category_db["category_id"], "f1234%$@Fng")
        category_db = select_last_category
        expect(category_db["category_name"]).to eq("f1234%$@Fng")
      end
    end

    context "Category Delete?" do
      it 'return true' do
        category_db = select_last_category
        max_id = category_db["category_id"]
        category = Category.delete_category_by_id(max_id)
        category_db = select_last_category
        expect(category_db["category_id"]).not_to eq(max_id)
      end
    end
  end
end
