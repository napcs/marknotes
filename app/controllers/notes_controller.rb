# NotesController provides the backend to create, read, update, share, and unshare notes.
# It also provides functionality to soft-delete notes.
class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy, :share, :unshare]
  before_action :set_tags, only: [:new, :edit, :update, :create]

  # GET /notes
  # GET /notes.json
  def index
    if params[:query]
      @notes = current_user.notes.find_all_by_keyword(params[:query]).page(params[:page]).per(10)

    else
      @notes = current_user.notes.visible.page(params[:page]).per(10)
    end
  end

  # Present the form for creating a new note.
  # GET /notes/new
  def new
    @note = current_user.notes.build
  end

  # Present the form to edit a note.
  # GET /notes/1/edit
  def edit
  end

  # Process request to persist a note to the database.
  # POST /notes
  # POST /notes.json
  def create
    @note = current_user.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to edit_note_path(@note), notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # Process the request to Update a note in the database.
  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to edit_note_path(@note), notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # Process request to share a note by creating a slug and updating the database
  def share
    respond_to do |format|
      @note.share
      if @note.save
        format.html { redirect_to edit_note_path(@note), notice: 'Note was successfully shared.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # Process the request to unshare a note by removing the slug value from the database
  def unshare
    respond_to do |format|
      @note.unshare
      if @note.save
        format.html { redirect_to edit_note_path(@note), notice: 'Note was successfully unshared.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # Process the request to soft-delete a note.
  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.deleted = true
    @note.save
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully moved to the trash.' }
      format.json { head :no_content }
    end
  end


  # Convert the given markdown to HTML
  # POST notes/process_markdown
  def process_markdown
    text_to_transform = params[:text]

    html = Kramdown::Document.new(text_to_transform).to_html

    render :text => html
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = current_user.notes.find(params[:id])
    end

    # Get the tags for the current user for use in the autocomplete menu on
    # the note form
    def set_tags
      @tags = current_user.tags.collect{|t| t.name}.to_json
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :tags, :body, :tag_list)
    end
end
