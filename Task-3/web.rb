require 'sinatra'
require './db_connector'

get '/' do
  items = get_all_items
  erb :index, locals: {
    items: items
  }
end

get '/items/new' do
  categories = get_all_categories
  erb :create, locals: {
    categories: categories
  }
end

post '/items/create' do
  name = params['food-name']
  price = params['food-price']
  description = params['food-desc']
  categories = params['food-categories']
  p create_new_item(name, price, description, categories)
  redirect '/'
end

get '/items/detail/:id' do
  item = get_item_detail(params['id'])
  erb :detail, locals: {
    item: item
  }
end

get '/items/edit/:id' do
  item = get_item_detail(params['id'])
  categories = get_all_categories
  erb :edit, locals: {
    item: item,
    categories: categories
  }
end

post '/items/update/:id' do
  item = get_item_detail(params['id'])
  categories = get_all_categories
  update_item_detail(item.id, params['food-name'], params['food-price'], params['food-desc'], params['food-categories'])
  redirect "/"
end

get '/items/delete/:id' do
  delete_item(params['id'])
  redirect '/'
end