class AddCartlistToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cartlist, :text
  end
end
