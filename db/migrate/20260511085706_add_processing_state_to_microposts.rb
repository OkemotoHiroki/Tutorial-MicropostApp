class AddProcessingStateToMicroposts < ActiveRecord::Migration[8.1]
  def change
    add_column :microposts, :processing_state, :integer, null: false, default: 0
  end
end
