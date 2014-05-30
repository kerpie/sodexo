module ApplicationHelper

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def my_month(number)
  	case number
  	when 1
  		"Enero"
  	when 2
  		"Febrero"
  	when 3
  		"Marzo"
  	when 4
  		"Abril"
  	when 5
  		"Mayo"
  	when 6
  		"Junio"
  	when 7
  		"Julio"
  	when 8
  		"Agosto"
  	when 9
  		"Septiembre"
  	when 10
  		"Octubre"
  	when 11
  		"Noviembre"
  	when 12
  		"Diciembre"
  	end
  end

end