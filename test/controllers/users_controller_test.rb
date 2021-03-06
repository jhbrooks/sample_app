require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:example)
    @user_two = users(:example_two)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
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

  test "should not allow the admin attribute to be updated via the web" do
    log_in_as(@user_two)
    assert_not @user_two.admin?
    patch :update, id: @user_two, user: { password: 'password',
                                          password_confirmation: 'password',
                                          admin: true}
    assert_not @user_two.reload.admin?
  end

  test "should redirect edit when logged in as the wrong user" do
    log_in_as(@user_two)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as the wrong user" do
    log_in_as(@user_two)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user_two)
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
