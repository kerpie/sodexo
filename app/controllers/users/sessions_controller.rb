class Users::SessionsController < Devise::SessionsController

	def create
		if request.xhr?
			email = params["email"]
			password = params["password"]
			user = User.find_by(email: email)
			if user.nil?
				return render json: {success: false, message: "Correo o contraseña incorrectos"}
			end
			result = user.valid_password?(password)
			unless result
				return render json: {success: false, message: "Correo o contraseña incorrectos"}
			else
				return render json: {success: true, token: user.authentication_token}
			end
		else
			super
		end
	end

=begin
	def create
		if request.xhr?
			resource = warden.authenticate!(:scope => resource_name, :recall => '#{controller_path}#failure')
			return render json: {success: true, token: resource.authentication_token }
			#sign_in_and_redirect(resource_name, resource)
		else
			super
		end
	end
	
	def sign_in_and_redirect(resource_or_scope, resource=nil)
		scope = Devise::Mapping.find_scope!(resource_or_scope)
		resource ||= resource_or_scope
		#sign_in(scope, resource) unless warden.user(scope) == resource
		return render :json => {:success => true, token: resource.authentication_token}
	end
	
	def failure
		return render :json => {:success => false, :errors => ['Login failed']}
	end
=end
end