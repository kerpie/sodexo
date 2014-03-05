class Question < ActiveRecord::Base

	belongs_to :sub_category
	has_many :availabilities
	has_many :restaurants, through: :availabilities
	has_many :alternatives

	def long_name
		title + " - " + sub_category.name
	end

	def add_alternatives
		my_alternatives = []
		values = %w(Si No)
		values.each do |value|
			my_alternative = Alternative.new
			my_alternative.name = value
			my_alternatives << my_alternative
		end
		my_alternatives
	end
end