json.status @result[0]
if @result[0]
	json.total @result[1]
	json.day_index @result[2]
	json.data @result[3]
else
	json.message "No existe informacion del local indicado en ese mes"
end