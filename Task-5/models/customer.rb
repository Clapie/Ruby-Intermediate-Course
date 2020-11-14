require './db/db_connector.rb'

class Customer
  attr_accessor :id, :name, :phone_number

  def initialize(id, name, phone_number)
    @id = id
    @name = name
    @phone_number = phone_number
  end

  def self.get_all_customers(search="")
    client = create_db_client
    if search == ""
      rawCustomers = client.query("select * from customers")
    else
      rawCustomers = client.query("select * from customers where customer_name like '%#{search}%';")
    end

    customers = Array.new
    rawCustomers.each do |customer|
      customers.push(Customer.new(customer["customer_id"], customer["customer_name"], customer["customer_phone"]))
    end
    customers
  end

  def self.get_all_customers_list
    client = create_db_client
    rawCustomers = client.query("select * from customers")

    customers_name = Array.new
    customers_phone = Array.new
    rawCustomers.each do |customer|
      customers_name.push(customer["customer_name"])
      customers_phone.push(customer["customer_phone"])
    end

    [customers_name, customers_phone]
  end

  def self.create_new_customer(name, phone)
    client = create_db_client
    client.query("insert into customers (customer_name, customer_phone) values ('#{name}', '#{phone}')")
  end

  def self.get_customer_detail(id)
    client = create_db_client
    rawCustomer = client.query("select * from customers where customer_id = '#{id}'").first
    customer = Customer.new(rawCustomer["customer_id"], rawCustomer["customer_name"], rawCustomer["customer_phone"])
    customer
  end

  def self.update_customer_detail(id, name, phone)
    client = create_db_client
    client.query("update customers set customer_name='#{name}', customer_phone='#{phone}' where customer_id = '#{id}'")
  end

  def self.delete_customer_by_id(id)
    client = create_db_client
    client.query("delete from customers where customer_id = '#{id}'")
  end
end