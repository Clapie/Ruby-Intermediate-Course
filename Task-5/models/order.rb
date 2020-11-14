require './db/db_connector.rb'

class Order
  attr_accessor :id, :user, :customer, :order_date, :total_price, :items

  def initialize(id, user, customer, order_date, total_price, items = nil)
    @id = id
    @user = user
    @customer = customer
    @order_date = order_date
    @total_price = total_price
    @items = items
  end

  def self.get_all_orders(search="")
    client = create_db_client
    if search == ""
      rawOrders = client.query("select o.order_id,
                                      o.order_date,
                                      c.customer_id,
                                      c.customer_name,
                                      c.customer_phone,
                                      u.user_id,
                                      u.user_name,
                                      sum(od.item_qty * i.item_price)  Total,
                                      group_concat(i.item_name separator ', ') Items_Bought
                                from order_details od
                                    inner join orders o on od.order_id = o.order_id
                                    inner join customers c on c.customer_id = o.customer_id
                                    inner join items i on od.item_id = i.item_id
                                    inner join users u on o.user_id = u.user_id
                                group by o.order_id;")
    else
      rawOrders = client.query("select o.order_id,
                                      o.order_date,
                                      c.customer_id,
                                      c.customer_name,
                                      c.customer_phone,
                                      u.user_id,
                                      u.user_name,
                                      sum(od.item_qty * i.item_price)  Total,
                                      group_concat(i.item_name separator ', ') Items_Bought
                                from order_details od
                                    inner join orders o on od.order_id = o.order_id
                                    inner join customers c on c.customer_id = o.customer_id
                                    inner join items i on od.item_id = i.item_id
                                    inner join users u on o.user_id = u.user_id
                                where c.customer_name like '%#{search}%'
                                group by o.order_id;")
    end

    orders = Array.new
    rawOrders.each do |order|
      user = User.new(order["user_id"], order["user_name"])
      customer = Customer.new(order["customer_id"], order["customer_name"], order["customer_phone"])
      orders.push(Order.new(
                              order["order_id"],
                              user,
                              customer,
                              order["order_date"],
                              order["Total"],
                              order["Items_Bought"]
                            ))
    end
    orders
  end

  def self.create_new_order(user_id, customer_id, order_date, item_ids, item_qtys)
    client = create_db_client
    client.query("insert into orders (user_id, customer_id, order_date) values ('#{user_id}', '#{customer_id}', '#{order_date}')")
    rawOrder = client.query("select max(order_id) from orders").first
    order_id = rawOrder["max(order_id)"]

    item_ids.each_with_index do |item_id, index|
      client.query("insert into order_details (order_id, item_id, item_qty) values ('#{order_id}', '#{item_ids[index]}', '#{item_qtys[index]}')")
    end
  end

  def self.get_order_detail(id)
    client = create_db_client
    rawOrders = client.query("select o.order_id,
                                     o.order_date,
                                     c.customer_id,
                                     c.customer_name,
                                     c.customer_phone,
                                     u.user_id,
                                     u.user_name,
                                     sum(od.item_qty * i.item_price)  Total,
                                     group_concat(i.item_name separator ', ') Items_Bought
                              from order_details od
                                   inner join orders o on od.order_id = o.order_id
                                   inner join customers c on c.customer_id = o.customer_id
                                   inner join items i on od.item_id = i.item_id
                                   inner join users u on o.user_id = u.user_id
                              where o.order_id = '#{id}'
                              group by o.order_id;
    ").first

    user = User.new(rawOrders["user_id"], rawOrders["user_name"])
    customer = Customer.new(rawOrders["customer_id"], rawOrders["customer_name"], rawOrders["customer_phone"])
    order = Order.new(
                      rawOrders["order_id"],
                      user,
                      customer,
                      rawOrders["order_date"],
                      rawOrders["Total"],
                      rawOrders["Items_Bought"]
                    )
  end
end