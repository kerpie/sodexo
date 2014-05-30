$ ->
	$("#restaurant_id_for_survey").change ->
		$(this).parents("form").submit()
		$("#loading_part").show()

$ ->
	$(document).on "click", ".daily_arrow_head", ->
		$("#daily_summary").hide()
		to_show = $(this).data("point-to")
		hide_daily_parts()
		$("#daily_labels").hide()
		$("#"+to_show).show();

$ ->
	$(document).on "click", ".daily_back_button", (e)->
		e.preventDefault()
		hide_daily_parts()
		$("#daily_labels").show()
		$("#daily_summary").show()

hide_daily_parts = ->
	$('.daily_sub_category_value').each ->
		$(this).hide()
	$('.monthly_sub_category_value').each ->
		$(this).hide()

$ ->
	$("#search_monthly_result").submit ->
		$("#loading_part").show()

$ ->
	$(document).on "click", ".monthly_arrow_head", ->
		$("#monthly_summary").hide()
		to_show = $(this).data("point-to")
		hide_daily_parts()
		$("#"+to_show).show();

$ ->
	$(document).on "click", ".monthly_back_button", (e)->
		e.preventDefault()
		hide_daily_parts()
		$("#daily_labels").show()
		$("#monthly_summary").show()

$ ->
	$(document).on "click", ".total_back_button", (e)->
		e.preventDefault()
		hide_daily_parts()
		$("#daily_labels").show()
		$("#monthly_summary").show()

$ ->
	$(document).on "click", ".clickable", (e) ->
		$(this).parents(".monthly_sub_category_value").hide()
		to_show = $(this).data("point-to")
		$("#daily_labels").hide()
		$("#"+to_show).show();