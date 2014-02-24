class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.time :start_time
      t.time :end_time
      t.integer :category_id

      t.timestamps
    end
  end
end
