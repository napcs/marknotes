require 'test_helper'

class TrashedNotesControllerTest < ActionController::TestCase
  setup do
    @user = User.create! email: "test@example.com", password: "111abc123!", password_confirmation: "111abc123!"
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "should restore note" do
    note = Note.first
    note.user = @user
    note.deleted = true
    note.save

    sign_in @user

    put :restore, id: Note.first.id
    assert_redirected_to trashed_notes_path
  end

  test "should destroy note" do
    note = Note.first
    note.user = @user
    note.deleted = true
    note.save

    sign_in @user

    assert_difference('Note.count', -1) do
      delete :destroy, id: Note.first.id
    end

    assert_redirected_to trashed_notes_path
  end

  test "should delete all trashed notes" do
    # clean database
    Note.delete_all

    note1 =  Note.create! user: @user, title: "test note", body: "this is a test", tag_list: "homework, school"
    note2 = Note.create! user: @user, title: "test note 2", body: "this is a test", tag_list: "homework, school"
    note3 = Note.create!  title: "test note 3", body: "this is a test", tag_list: "homework, school"

    note1.deleted = true
    note1.save

    sign_in @user
    delete :empty

    assert_nil @user.notes.find_by_title("test note")
    assert_not_nil @user.notes.find_by_title("test note 2")
    assert_not_nil Note.find_by_title("test note 3")

  end

end
