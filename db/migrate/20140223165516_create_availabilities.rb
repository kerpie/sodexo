class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.integer :question_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
