# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

calculate = (expr) ->
  $.ajax(
    type: 'GET',
    url: "/calculate.json?" + expr,
    data: { 'expr' : expr },
    success: alert(expr),
    datatype: 'text'
  )
