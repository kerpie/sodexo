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
			build_resource(sign_up_params)
			resource_saved = resource.save
			yield resource if block_given? 
			if resource_saved
				if resource.active_for_authentication?
					set_flash_message :notice, :signed_up if is_flashing_format?
					if(params[:user][:user_type_id] == '1')
						resource.restaurants << Restaurant.find(params[:restaurant_id_for_user])
					else
						Restaurant.all.each do |r|
							resource.restaurants << r
						end
					end
					sign_up(resource_name, resource)
					respond_with resource, location: after_sign_up_path_for(resource)
				else
					set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
					expire_data_after_sign_in!
					respond_with resource, location: after_inactive_sign_up_path_for(resource)
					end
			else
				clean_up_passwords resource
				respond_with resource
			end
		else
			return 
		end
	end	

	def sign_up(resource_name, resource)
		return
	end

	def sign_up_params
		params.require(:user).permit(:email, :password, :password_confirmation, :user_type_id, :restaurant_id_for_user)
	end

end