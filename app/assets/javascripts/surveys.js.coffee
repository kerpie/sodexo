$ ->
	$("#restaurant_id_for_survey").change ->
		$(this).parents("form").submit()
		$("#loading_part").show()