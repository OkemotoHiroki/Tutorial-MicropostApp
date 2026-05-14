require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    assert_no_difference "Relationship.count" do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference "Relationship.count" do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end

  test "create when logged in creates a relationship" do
    log_in_as(users(:michael))
    other = users(:lana)  # not yet followed by archer; michael follows lana already via fixture
    # Use archer who doesn't follow lana
    log_in_as(users(:archer))
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: { followed_id: users(:lana).id }
    end
    assert_response :redirect
  end

  test "destroy when logged in destroys a relationship" do
    log_in_as(users(:michael))
    relationship = relationships(:one)  # michael follows lana
    assert_difference "Relationship.count", -1 do
      delete relationship_path(relationship)
    end
    assert_response :redirect
  end
end
