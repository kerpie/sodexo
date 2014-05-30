$ ->
	$(document).on "click", ".summary h2",->
		value = $(this).data("key-value")
		$(".hidden_data").each ->
			$(this).hide()
		$("[data-cat="+value+"]").show()