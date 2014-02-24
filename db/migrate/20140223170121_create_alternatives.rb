class CreateAlternatives < ActiveRecord::Migration
  def change
    create_table :alternatives do |t|
      t.string :name
      t.integer :question_id

      t.timestamps
    end
  end
end
