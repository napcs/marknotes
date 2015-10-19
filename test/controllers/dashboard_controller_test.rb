require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    @user = User.create! email: "test@example.com", password: "111abc123!", password_confirmation: "111abc123!"
  end

  test "should get show" do
    sign_in @user
    get :show
    assert_response :success
  end

end
