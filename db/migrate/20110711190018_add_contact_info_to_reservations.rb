class AddContactInfoToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :firstname, :string
    add_column :reservations, :lastname, :string
    add_column :reservations, :address, :string
    add_column :reservations, :phone, :string
    add_column :reservations, :email, :string
  end

  def self.down
    remove_column :reservations, :firstname, :string
    remove_column :reservations, :lastname, :string
    remove_column :reservations, :address, :string
    remove_column :reservations, :phone, :string
    remove_column :reservations, :email, :string
  end
end
