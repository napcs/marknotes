require 'test_helper'

class SharedNotesControllerTest < ActionController::TestCase
  test "should get show" do
    note = Note.first
    note.share
    note.save

    get :show, id: note.slug
    assert_not_nil assigns[:note]
    assert_response :success
  end

end
