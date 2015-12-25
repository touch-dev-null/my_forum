ready = ->
  $('#post_preview').click (event) ->
    event.preventDefault()

    elm_id  = $(event.target).data('elm-preview')
    elm     = $('#' + elm_id)

    return unless elm

    data = elm.val()

    $.ajax
      url: '/post/preview'
      type: 'POST'
      dataType: 'script'
      data:
        text: data

$(document).ready(ready)
$(document).on('page:load', ready)