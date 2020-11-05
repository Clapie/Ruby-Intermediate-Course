require 'sinatra'
require './controllers/item_controller.rb'
require './controllers/category_controller.rb'

get '/' do
  controller = ItemController.new
  controller.show_all_items
end

# Items
get '/items' do
  controller = ItemController.new
  controller.show_all_items
end

get '/items/new' do
  controller = ItemController.new
  controller.new_item
end

post '/items/create' do
  controller = ItemController.new
  controller.create_item(params)
  redirect '/items'
end

get '/items/detail/:id' do
  controller = ItemController.new
  controller.show_item_details(params)
end

get '/items/edit/:id' do
  controller = ItemController.new
  controller.edit_item(params)
end

post '/items/update/:id' do
  controller = ItemController.new
  controller.update_item(params)
  redirect '/items'
end

get '/items/delete/:id' do
  controller = ItemController.new
  controller.delete_item(params)
  redirect '/items'
end

# Categories
get '/categories' do
  controller = CategoryController.new
  controller.show_all_categories
end

get '/categories/new' do
  controller = CategoryController.new
  controller.new_category
end

post '/categories/create' do
  controller = CategoryController.new
  controller.create_category(params)
  redirect '/categories'
end

get '/categories/detail/:id' do
  controller = CategoryController.new
  controller.show_category_details(params)
end

get '/categories/edit/:id' do
  controller = CategoryController.new
  controller.edit_category(params)
end

post '/categories/update/:id' do
  controller = CategoryController.new
  controller.update_category(params)
  redirect '/categories'
end

get '/categories/delete/:id' do
  controller = CategoryController.new
  controller.delete_category(params)
  redirect '/categories'
end