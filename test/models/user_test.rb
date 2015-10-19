require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "can find notes for user by tag" do
    user = User.create! email: "test@example.com", password: "111abc123!", password_confirmation: "111abc123!"
    user.notes.create title: "abc note", tag_list: "homework", body: "this is a note"

    assert_equal "abc note", user.notes.tagged_with("homework").first.title

  end


end
