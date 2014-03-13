json.status @result[0]
if @result[0]
	json.total @result[1]
	json.hash_data @result[2]
	json.hash_days @result[3]
else
	json.message "No existe informacion del local indicado en ese mes"
end