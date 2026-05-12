class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  enum :processing_state, {
    pending: 0,
    processing: 1,
    done: 2,
    failed: 3
  }
  has_one_attached :picture

  validate :picture_size


  def spam_scored?
    spam_score.present?
  end

  def angry_scored?
    angry_score.present?
  end

  private

  def picture_size
    if picture.attached? && picture.byte_size > 5.megabytes
      errors.add(:picture, :too_large, message: "5MB以下にしてください")
    end
  end
end
