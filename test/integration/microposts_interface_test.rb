require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @user_two = users(:example_two)
    @user_three = users(:example_three)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_template "static_pages/_logged_in_home"
    assert_select "div.pagination"

    # Invalid post
    assert_no_difference "Micropost.count" do
      post microposts_path, micropost: { content: "" }
    end
    assert_template "static_pages/_logged_in_home"
    assert_select 'div#error_explanation'

    # Valid post
    content = "Lorem ipsum."
    assert_difference "Micropost.count", 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/_logged_in_home"
    assert_not flash.empty?
    assert_match content, response.body

    # Delete a post.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/_logged_in_home"
    assert_not flash.empty?

    # Visit a different user.
    get user_path(@user_two)
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    # User with some number of microposts
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    # User with zero microposts
    log_in_as(@user_three)
    get root_path
    assert_match "0 microposts", response.body
    @user_three.microposts.create!(content: "Lorem ipsum.")
    get root_path
    assert_match "1 micropost", response.body
  end
end
