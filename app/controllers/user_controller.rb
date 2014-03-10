class UserController < ApplicationController

	def session_for_mobile
		email = params[:email]
		password = params[:password]
		user = User.find_by(email: email)
		respond_to do |format|
			if user.nil?
				return render json: { status: false, message: "Usuario o contraseña incorrectos" }
			end
			if user.valid_password?(password)
				return render json: { status: true, token: user.authentication_token }
			else
				return render json: { status: false, message: "Usuario o contraseña incorrectos" }
			end
		end
	end

end