require './db/db_connector.rb'
require './models/customer.rb'

class CustomerController
  def show_all_customers(params=nil)
    customers = Customer.get_all_customers(params["search"])
    renderer = ERB.new(File.read('./views/customers/index.erb'))
    renderer.result(binding)
  end

  def new_customer
    customers = Customer.get_all_customers
    renderer = ERB.new(File.read('./views/customers/create.erb'))
    renderer.result(binding)
  end

  def create_customer(params)
    name = params['customer-name']
    phone = params['customer-phone']
    Customer.create_new_customer(name, phone)
  end

  def show_customer_details(params)
    customer = Customer.get_customer_detail(params['id'])
    renderer = ERB.new(File.read('./views/customers/detail.erb'))
    renderer.result(binding)
  end

  def edit_customer(params)
    customer = Customer.get_customer_detail(params['id'])
    renderer = ERB.new(File.read('./views/customers/edit.erb'))
    renderer.result(binding)
  end

  def update_customer(params)
    customer = Customer.get_customer_detail(params['id'])
    Customer.update_customer_detail(customer.id, params['customer-name'], params['customer-phone'])
  end

  def delete_customer(params)
    Customer.delete_customer_by_id(params['id'])
  end
end