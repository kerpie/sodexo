class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :choosen_question_id
      t.integer :alternative_id

      t.timestamps
    end
  end
end
