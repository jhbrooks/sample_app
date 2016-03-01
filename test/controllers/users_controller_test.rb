require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", full_title("Sign up")
  end

  test "should post create" do
    post :create, user: { name: "Ex",
                          email: "ex@example.com",
                          password: "3x4mp13",
                          password_confirmation: "3x4mp13" }
    assert_response :redirect
  end
end
