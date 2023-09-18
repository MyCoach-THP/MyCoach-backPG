class AddOrderedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :ordered, :text
  end
end
