class Question < ActiveRecord::Base

	belongs_to :sub_category
	has_many :availabilities
	has_many :restaurants, through: :availabilities
	has_many :alternatives

	def long_name
		title + " - " + sub_category.name
	end
end