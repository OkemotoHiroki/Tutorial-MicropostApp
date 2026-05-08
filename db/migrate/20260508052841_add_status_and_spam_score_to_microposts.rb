class AddStatusAndSpamScoreToMicroposts < ActiveRecord::Migration[8.1]
  def change
    add_column :microposts, :status, :string, default: "safe"
    add_column :microposts, :spam_score, :float
  end
end
