class Events < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :event_name, null: false
      t.date :date_at, null: false

      t.timestamps
    end
  end
end
