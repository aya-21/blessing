class AddEventIdToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :event_id, :integer
  end
end
