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
