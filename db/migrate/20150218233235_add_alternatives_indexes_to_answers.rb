class AddAlternativesIndexesToAnswers < ActiveRecord::Migration
  def change
  	add_index :answers, :alternative_id
  end
end
