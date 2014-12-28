module WikiHelper
  # Get the CSS class for the wiki menu.
  # @param [String] current_path The currently viewed path.
  # @param [String] wiki_page The wiki page we're getting the class for.
  # @return [String] The CSS class applied to the menu item.
  def wiki_menu_class(current_path:, wiki_page:)
    (current_path == wiki_page) ? 'list-group-item active' : 'list-group-item'
  end
end
