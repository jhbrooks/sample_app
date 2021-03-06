require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  def setup
    @relationship = relationships(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Relationship.count" do
      post :create
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Relationship.count" do
      delete :destroy, id: @relationship
    end
    assert_redirected_to login_url
  end
end
