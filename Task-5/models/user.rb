require './db/db_connector.rb'

class User
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.get_user_name(id)
    client = create_db_client
    rawUser = client.query("select * from users where user_id = '#{id}'").first

    user = User.new(rawUser["user_id"], rawUser["user_name"])
    user
  end

  def self.get_all_users
    client = create_db_client
    rawUsers = client.query("select * from users")

    users = Array.new
    rawUsers.each do |user|
      users.push(User.new(user["user_id"], user["user_name"]))
    end
    users
  end
end