class AddModerationToMicroposts < ActiveRecord::Migration[8.1]
  def change
    add_column :microposts, :is_angry, :boolean, default: false, null: false
    add_column :microposts, :angry_score, :float
    add_column :microposts, :reason, :text
    add_column :microposts, :summary, :text
  end
end
