require './db/db_connector.rb'
require './models/item.rb'
require './models/category.rb'

class CategoryController
  def show_all_categories
    categories = Category.get_all_categories
    renderer = ERB.new(File.read('./views/categories/index.erb'))
    renderer.result(binding)
  end

  def new_category
    categories = Category.get_all_categories
    renderer = ERB.new(File.read('./views/categories/create.erb'))
    renderer.result(binding)
  end

  def create_category(params)
    name = params['category-name']
    Category.create_new_category(name)
  end

  def show_category_details(params)
    category = Category.get_category_detail(params['id'])
    renderer = ERB.new(File.read('./views/categories/detail.erb'))
    renderer.result(binding)
  end

  def edit_category(params)
    category = Category.get_category_detail(params['id'])
    renderer = ERB.new(File.read('./views/categories/edit.erb'))
    renderer.result(binding)
  end

  def update_category(params)
    category = Category.get_category_detail(params['id'])
    Category.update_category_detail(category.id, params['category-name'])
  end

  def delete_category(params)
    Category.delete_category_by_id(params['id'])
  end
end