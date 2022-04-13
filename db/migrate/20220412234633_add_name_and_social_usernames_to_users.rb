class AddNameAndSocialUsernamesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :twitter_username, :string
    add_column :users, :discord_username, :string
  end
end
