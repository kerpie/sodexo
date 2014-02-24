class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :item
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
