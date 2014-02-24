class Availability < ActiveRecord::Base

	belongs_to :restaurant
	belongs_to :question

end