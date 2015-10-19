# TagsController provides the backend to display all tags for a user
# and display notes for a given tag
class TagsController < ApplicationController

  # Prepare and display an alphabetical list of tags for the current user
  # GET /index
  def index
    @grouped = {}
    current_user.tags.each do |tag|
      letter = tag.name.slice(0,1).upcase
      @grouped[letter] ||= []
      @grouped[letter] << tag unless @grouped[letter].include? tag
    end
  end

  # Locate notes for a given tag by name
  # GET /show/:id  (where :id is the tag name, not database column)
  def show
    @name = CGI.unescape params[:id]
    @notes = current_user.notes.tagged_with @name   # provided by ActsAsTaggable
  end
end
