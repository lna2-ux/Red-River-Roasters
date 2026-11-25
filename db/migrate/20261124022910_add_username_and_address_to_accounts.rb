class AddUsernameAndAddressToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :username, :string
    add_column :accounts, :street_address, :string
    add_column :accounts, :city, :string
    add_column :accounts, :postal_code, :string
    add_reference :accounts, :province, null: false, foreign_key: true
  end
end
