class CreateChoosenQuestions < ActiveRecord::Migration
  def change
    create_table :choosen_questions do |t|
      t.integer :availability_id
      t.integer :survey_id

      t.timestamps
    end
  end
end
