require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Ex", email: "ex@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user_one = users(:example)
    @user_two = users(:example_two)
    @user_four = users(:example_four)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-er@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com USER_at_foo.com user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..net
                           foo@bar..bar..baz.com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do
    address_with_uppercase = "Ex@Example.COM"
    @user.email = address_with_uppercase
    @user.save
    assert_equal address_with_uppercase.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # Note: has_secure_password implements this validation
  test "password should not be too long" do
    @user.password = @user.password_confirmation = "a" * 73
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  test "associated microposts should be destroyed with their user" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum.")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    assert_not @user_two.following?(@user_four)
    @user_two.follow(@user_four)
    assert @user_two.following?(@user_four)
    assert @user_four.followers.include?(@user_two)
    @user_two.unfollow(@user_four)
    assert_not @user_two.following?(@user_four)
  end

  test "feed should have the right posts" do
    # Posts from followed user
    @user_two.microposts.each do |post_following|
      assert @user_one.feed.include?(post_following)
    end
    # Posts from self
    @user_one.microposts.each do |post_self|
      assert @user_one.feed.include?(post_self)
    end
    # Posts from unfollowed user
    @user_four.microposts.each do |post_unfollowed|
      assert_not @user_one.feed.include?(post_unfollowed)
    end
  end
end
