class AddStatusToOccupation < ActiveRecord::Migration[5.0]
  def change
    add_column :occupations, :status, :integer
  end
end
