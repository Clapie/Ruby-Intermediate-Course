require './models/customer.rb'
require './db/db_connector.rb'

class Customer
  def valid?
    return false if @id.nil?
    return false if @name.nil?
    return false if @phone_number.nil? && @phone_number.to_i.to_s != @phone_number
    true
  end
end

def select_last_customer
  create_db_client.query("select * from customers order by customer_id desc limit 1").first
end

describe Customer do
  describe 'customer.valid?' do
    context "Init valid input" do
      it 'return true' do
        customer = Customer.new(1, "TESTING", "081234123")
        expect(customer.valid?).to eq(true)
      end
    end
  end

  describe 'CRUD Customer' do
    context "Customer Create?" do
      it 'return true' do
        customer = Customer.create_new_customer("TESTING", "123412341234")
        customer_db = select_last_customer
        expect(customer_db["customer_name"]).to eq("TESTING")
        expect(customer_db["customer_phone"]).to eq("123412341234")
      end
    end

    context "Customer Read?" do
      it 'return true' do
        customer_db = select_last_customer
        max_id = customer_db["customer_id"]
        customer = Customer.get_customer_detail(max_id)
        expect(customer.name).to eq("TESTING")
        expect(customer.phone_number).to eq("123412341234")
      end
    end

    context "Customer Update?" do
      it 'return true' do
        customer_db = select_last_customer
        customer = Customer.update_customer_detail(customer_db["customer_id"], "f1234%$@Fng", "12341298234")
        customer_db = select_last_customer
        expect(customer_db["customer_name"]).to eq("f1234%$@Fng")
        expect(customer_db["customer_phone"]).to eq("12341298234")
      end
    end

    context "Customer Delete?" do
      it 'return true' do
        customer_db = select_last_customer
        max_id = customer_db["customer_id"]
        customer = Customer.delete_customer_by_id(max_id)
        customer_db = select_last_customer
        expect(customer_db["customer_name"]).not_to eq("f1234%$@Fng")
        expect(customer_db["customer_phone"]).not_to eq("12341298234")
      end
    end
  end
end
