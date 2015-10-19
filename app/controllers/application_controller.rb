# ApplicationController is the parent controller for all other controllers.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_deleted_notes_count

  private
    # For use in the layout. Shows the notes in the trash. Runs on every
    # request as a before_action.
    def get_deleted_notes_count
      @deleted_notes_count = Note.deleted.count
    end

end
