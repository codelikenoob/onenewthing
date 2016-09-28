class CreateOccupations < ActiveRecord::Migration[5.0]
  def change
    create_table :occupations do |t|
      t.integer :user_id
      t.integer :thing_id

      t.timestamps
    end
    add_index :occupations, :user_id
    add_index :occupations, :thing_id
  end
end
