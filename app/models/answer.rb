class Answer < ActiveRecord::Base

	belongs_to :choosen_question
	belongs_to :alternatives

end