require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @user = User.create! email: "test@example.com", password: "111abc123!", password_confirmation: "111abc123!"
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "should get show" do
    sign_in @user
    get :show, id: "homework"
    assert_response :success
    assert_select("h1", "Showing notes tagged with \"homework\"")
  end

  test "should properly escape multiple word tags" do
    sign_in @user
    get :show, id: "homework+for+IT"
    assert_select("h1", "Showing notes tagged with \"homework for IT\"")
  end

end
