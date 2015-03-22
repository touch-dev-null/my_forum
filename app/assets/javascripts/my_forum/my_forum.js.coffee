ready = ->
  $('.autocomplete').keyup (elm) ->
    ajax_url = $(@).data('autocomplete-path')
    return unless ajax_url

    $.ajax
      url: ajax_url
      type: "GET"
      dataType: "json"
      data: str: $(elm.target).val()
      success: (response) ->
        autocomplete_popup(response, elm.target)

autocomplete_popup = (autocomplete_list, object) ->
  popup_id = 'autocomplete_popup'

  # Create or use existing Popup Window
  if $('#' + popup_id).length > 0
    popup_container = $('#' + popup_id)
  else
    popup_container = $("<div id='#{popup_id}'></div>")
    $(object).after(popup_container)

  # Show lists
  html_list = $('<ul/>')
  $.map autocomplete_list, (item) ->
    li = $('<li/>')
      .addClass('ui-menu-item')
      .attr('role', 'menuitem')
      .appendTo(html_list)

    a = $('<a/>')
      .addClass('ui-all')
      .text(item)
      .appendTo(li)

    li.click ->
      $(object).val(item)

      # Destroy popup after select tag
      popup_container.remove()

  popup_container.html(html_list)

$(document).ready(ready)
$(document).on('page:load', ready)