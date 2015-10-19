# SharedNotesController displays a shared note. It uses a different
# layout than other pages in the system. See layouts/shared_notes.html.erb
class SharedNotesController < ApplicationController

  # Display a shared note via its slug
  # GET /show/:id
  def show
    @note = Note.find_by_slug(params[:id])
    if @note
      render :show
    else
      render :notfound
    end
  end
end
