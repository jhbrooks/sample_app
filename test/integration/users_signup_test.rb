require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path user: { name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar" }
    end
    assert_template "users/new"
    assert_template "shared/_error_messages"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup" do
    get signup_path
    assert_difference "User.count", 1 do
      post_via_redirect users_path user: { name: "Ex",
                                           email: "ex@example.com",
                                           password: "3x4mp13",
                                           password_confirmation: "3x4mp13" }
    end
    assert_template "users/show"
    assert_not flash.empty?
  end
end
