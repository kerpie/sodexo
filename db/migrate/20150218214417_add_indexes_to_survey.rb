class AddIndexesToSurvey < ActiveRecord::Migration
  def change
  	add_index :surveys, :restaurant_id
  end
end