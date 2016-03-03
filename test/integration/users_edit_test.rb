require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end

  test "invalid edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: { name: "",
                                    email: "user@invalid",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template "users/edit"
    assert_template "shared/_error_messages"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = "edit_ex"
    email = "edit_ex@example.com"
    assert_template "users/edit"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
