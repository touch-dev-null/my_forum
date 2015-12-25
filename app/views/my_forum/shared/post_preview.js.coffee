coffee:
  $(document).ready ->
    $('#modal_post_preview').find('.modal-body').html("<%= j render(html: preview_html.html_safe) %>")
    $('#modal_post_preview').modal()