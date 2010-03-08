class CreateHistoryEvents < ActiveRecord::Migration
  def self.up
    create_table :history_events do |t|
      t.integer :phixter_id
      t.integer :status
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :history_events
  end
end
