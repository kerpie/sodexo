class Survey < ActiveRecord::Base

	belongs_to :restaurant
	has_many :choosen_questions
	has_many :availabilities, through: :choosen_questions

end