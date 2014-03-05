$ ->
	$("#restaurant_id_for_survey").change ->
		$(this).parents("form").submit()