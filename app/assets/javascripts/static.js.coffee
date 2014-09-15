# Parallax setup.
$(document).ready ->

  # cache the window object
  $window = $(window)
  $("section[data-type=\"background\"]").each ->

    # declare the variable to affect the defined data-type
    $scroll = $(this)
    $(window).scroll ->

      # HTML5 proves useful for helping with creating JS functions!
      # also, negative value because we're scrolling upwards
      yPos = -($window.scrollTop() / $scroll.data("speed"))

      # background position
      coords = "50% " + yPos + "px"

      # move the background
      $scroll.css backgroundPosition: coords
      return

    return

  return