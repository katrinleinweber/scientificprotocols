# Setup token field for protocol tags.
cache = {}
$("input.tokenize").tokenfield
  autocomplete:
    source: (request, response) ->
      term = request.term
      if term of cache
        response cache[term]
        return
      $.getJSON "/protocols/tags", request, (data, status, xhr) ->
        cache[term] = data
        response data
        return
      return
    delay: 100
  showAutocompleteOnFocus: true
  limit: 3

# Setup embed protocol button.
$(document).ready ->
  clip = new ZeroClipboard($("#d_clip_button"))
  $("#d_clip_button").tooltip()
  return

$(document).ready ->
  bindRaty()
  return

@bindRaty = ->
  $("#star").raty
    readOnly: true
    score: ->
      $(this).attr "data-score"
    path: "/assets"

  $("#user-star-update").raty
    score: ->
      $(this).attr "data-score"
    path: "/assets"
    click: (score, evt) ->
      $.ajax
        url: $(this).attr("data-path")
        type: "PATCH"
        data:
          score: score
      return

  $("#user-star-create").raty
    score: ->
      $(this).attr "data-score"
    path: "/assets"
    click: (score, evt) ->
      $.ajax
        url: $(this).attr("data-path")
        type: "POST"
        data:
          score: score
      return
  return


