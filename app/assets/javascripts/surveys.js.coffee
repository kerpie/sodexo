$ ->
	$("#restaurant_id_for_survey").change ->
		$(this).parents("form").submit()
		$("#loading_part").show()

$ ->
	$("#restaurant_id").change ->
		$(this).parents("form").submit()
		$("#loading_part").show()

$ ->
	$("#month").change ->
		$(this).parents("form").submit()
		$("#loading_part").show()

$ ->
	$("#year").change ->
		$(this).parents("form").submit()
		$("#loading_part").show()