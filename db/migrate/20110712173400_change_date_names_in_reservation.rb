class ChangeDateNamesInReservation < ActiveRecord::Migration
  def self.up
    rename_column :reservations, :start, :start_at
    rename_column :reservations, :end, :end_at
  end

  def self.down
    rename_column :reservations, :start_at, :start
    rename_column :reservations, :end_at, :end
  end
end
