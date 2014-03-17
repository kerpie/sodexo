class Users::RegistrationsController < Devise::RegistrationsController

	skip_before_filter :require_no_authentication

	def new
		if user_signed_in? && current_user.user_type == UserType.last
			super
		else
			redirect_to root_path
		end
	end

	def create
		if user_signed_in? && current_user.user_type == UserType.last
			super
		else
			return 
		end
	end	

	def sign_up(resource_name, resource)
		return
	end

end