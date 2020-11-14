require './models/order.rb'
require './db/db_connector.rb'

class Order
  def valid?
    return false if @id.nil?
    return false if @user.nil?
    return false if @customer.nil?
    return false if @order_date.nil?
    return false if @total_price.nil? && @total_price.to_i.to_s != @total_price
    true
  end
end

def select_last_order
  create_db_client.query("select * from orders order by order_id desc limit 1").first
end

describe Order do
  describe 'order.valid?' do
    context "Init valid input" do
      it 'return true' do
        order = Order.new(1, "TESTING", "TESTING", "TESTING", "90000")
        expect(order.valid?).to eq(true)
      end
    end
  end
end
