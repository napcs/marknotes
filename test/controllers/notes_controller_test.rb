require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  setup do
    @user = User.create! email: "test@example.com", password: "111abc123!", password_confirmation: "111abc123!"
    @note = Note.create! user: @user, title: "test note", body: "this is a test", tag_list: "homework, school"
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:notes)
  end

  test "should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should create note" do
    sign_in @user
    assert_difference('Note.count') do
      post :create, note: { body: @note.body, tag_list: "one, two", title: @note.title }
    end

    assert_redirected_to edit_note_path(assigns(:note))
  end

  test "should show note" do
    sign_in @user
    get :show, id: @note
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @note
    assert_response :success
  end

  test "should update note" do
    sign_in @user
    patch :update, id: @note, note: { body: @note.body, tag_list: "one, two", title: @note.title }
    assert_redirected_to edit_note_path(assigns(:note))
  end

  test "should share note" do
    sign_in @user
    patch :share, id: @note
    assert_not_nil assigns[:note].slug
    assert_redirected_to edit_note_path(assigns(:note))
  end

  test "should unshare note" do
    sign_in @user
    patch :unshare, id: @note
    assert_nil assigns[:note].slug
    assert_redirected_to edit_note_path(assigns(:note))
  end

  test "should move note to trash" do
    sign_in @user
    delete :destroy, id: @note

    note = Note.find_by_id(@note.id)
    assert note.deleted

    assert_redirected_to notes_path
  end
end
