class ChoosenQuestion < ActiveRecord::Base

	belongs_to :survey
	belongs_to :availability
	has_many :answers

end