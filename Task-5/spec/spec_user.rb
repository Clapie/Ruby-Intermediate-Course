require './models/user.rb'
require './db/db_connector.rb'

class User
  def valid?
    return false if @id.nil?
    return false if @name.nil?
    true
  end
end

describe User do
  describe 'user.valid?' do
    context "Init valid input" do
      it 'return true' do
        user = User.new(1, "TESTING")
        expect(user.valid?).to eq(true)
      end
    end
  end

  describe 'Get Username' do
    context "User.name?" do
      it 'return true' do
        create_db_client.query("insert into users (user_name, user_password) values ('TESTING', 'TESTING');")
        max_id = create_db_client.query("select * from users order by user_id desc limit 1").first
        user = User.get_user_name(max_id["user_id"])
        create_db_client.query("delete from users where user_id = #{max_id["user_id"]}")

        expect(user.name).to eq("TESTING")
      end
    end
  end
end
