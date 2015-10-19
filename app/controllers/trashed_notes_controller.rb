# TrashedNotesController provides the backend for viewing, deleting, and restoring
# notes.
class TrashedNotesController < ApplicationController
  before_action :authenticate_user!

  # Display notes in the trash can. Scoped to current user.
  def index
    @notes = current_user.notes.deleted
  end

  # Restore a note
  # PATCH /trashed_notes/:id/restore
  def restore
    note = current_user.notes.deleted.find(params[:id])
    note.deleted = false
    note.save
    redirect_to trashed_notes_path, notice: "Note successfully restored."
  end

  # Permanently delete a note
  # DELETE /trashed_notes/:id
  def destroy
    note = current_user.notes.deleted.find(params[:id])
    note.destroy
    redirect_to trashed_notes_path, notice: "Note successfully deleted forever."
  end

  # Delete all notes pending deletion.
  # DELETE trashed_notes/empty
  def empty
    current_user.notes.deleted.delete_all
    redirect_to trashed_notes_path, notice: "The trash was emptied."
  end
end
