require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:example)
  end

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

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
