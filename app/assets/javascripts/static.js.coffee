# Parallax setup.
$(document).ready ->

  # Cache the window object.
  $window = $(window)
  $("section[data-type=\"background\"]").each ->

    # Declare the variable to affect the defined data-type.
    $scroll = $(this)
    $(window).scroll ->

      # HTML5 proves useful for helping with creating JS functions!
      # also, negative value because we're scrolling upwards.
      yPos = -($window.scrollTop() / $scroll.data("speed"))

      # Background position.
      coords = "50% " + yPos + "px"

      # Move the background.
      $scroll.css backgroundPosition: coords
      return

    return

  return