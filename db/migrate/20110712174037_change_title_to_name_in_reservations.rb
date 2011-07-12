class ChangeTitleToNameInReservations < ActiveRecord::Migration
  def self.up
    rename_column :reservations, :title, :name
  end

  def self.down
    rename_column :reservations, :name, :title
  end
end
