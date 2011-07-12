class CreateItemsReservationsTable < ActiveRecord::Migration
  def self.up
    create_table :items_reservations, :id => false do |t|
      t.references :item, :reservation
    end
  end

  def self.down
    drop_table :items_reservations
  end
end
