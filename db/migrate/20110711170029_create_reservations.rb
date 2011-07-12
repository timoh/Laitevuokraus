class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.string :title
      t.integer :user_id
      t.datetime :start
      t.datetime :end
      t.float :fee

      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
