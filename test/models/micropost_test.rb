require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "spam_scored? returns false when spam_score is nil" do
    assert_not @micropost.spam_scored?
  end

  test "spam_scored? returns true when spam_score is present" do
    @micropost.spam_score = 0.9
    assert @micropost.spam_scored?
  end

  test "angry_scored? returns false when angry_score is nil" do
    assert_not @micropost.angry_scored?
  end

  test "angry_scored? returns true when angry_score is present" do
    @micropost.angry_score = 0.8
    assert @micropost.angry_scored?
  end

  test "processing_state defaults to pending" do
    @micropost.save!
    assert @micropost.pending?
  end

  test "picture is not required" do
    assert @micropost.valid?
  end
end
