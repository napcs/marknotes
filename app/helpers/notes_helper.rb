# NotesHelper provides functions for views that are related to displaying Notes.
module NotesHelper

  # Convert the given Markdown string to HTML.
  #
  #     result = markdown_to_html("# Hello")
  #     result
  #     => "<h1>Hello</h1>"
  #
  # Returns a safe string so it can be used in the view.
  # Returns an empty string if no value is passed in.
  def markdown_to_html(text)
    return "" if text.blank?
    Kramdown::Document.new(text).to_html.html_safe
  end
end
