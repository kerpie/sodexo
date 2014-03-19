json.array! @restaurants.each do |restaurant|
	json.extract! restaurant, :id, :name
end