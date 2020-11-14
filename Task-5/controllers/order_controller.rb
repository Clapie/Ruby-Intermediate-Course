require './db/db_connector.rb'
require './models/order.rb'
require './models/user.rb'
require './models/customer.rb'
require './models/item.rb'

class OrderController
  def show_all_orders(params=nil)
    orders = Order.get_all_orders(params["search"])
    renderer = ERB.new(File.read('./views/orders/index.erb'))
    renderer.result(binding)
  end

  def new_order
    orders = Order.get_all_orders
    customers = Customer.get_all_customers
    users = User.get_all_users
    items = Item.get_all_items
    renderer = ERB.new(File.read('./views/orders/create.erb'))
    renderer.result(binding)
  end

  def create_order(params)
    user_id = params['user-id']
    customer_id = params['customer-id']
    order_date = DateTime.now()
    item_ids = params['item-ids']
    item_qtys = params['item-qtys']
    Order.create_new_order(user_id, customer_id, order_date, item_ids, item_qtys)
  end

  def show_order_details(params)
    order = Order.get_order_detail(params['id'])
    renderer = ERB.new(File.read('./views/orders/detail.erb'))
    renderer.result(binding)
  end
end