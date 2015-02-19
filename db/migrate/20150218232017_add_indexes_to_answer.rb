class AddIndexesToAnswer < ActiveRecord::Migration
  def change
  	add_index :answers, :choosen_question_id
  end
end
