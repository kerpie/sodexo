class SubCategory < ActiveRecord::Base

	belongs_to :category 

	has_many :questions
	
	before_validation :change_time

	def change_time
		start_time = Time.zone.at self.start_time
		end_time = Time.zone.at self.end_time
	end

end