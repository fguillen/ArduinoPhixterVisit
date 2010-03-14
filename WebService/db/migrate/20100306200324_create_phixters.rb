class CreatePhixters < ActiveRecord::Migration
  def self.up
    create_table :phixters do |t|
      t.string :uri, :null => false
      t.string :value
      t.integer :status, :null => false, :default => 0
      t.integer :user_id
      t.string :hash_code
      t.timestamps
    end
  end
  
  def self.down
    drop_table :phixters
  end
end
