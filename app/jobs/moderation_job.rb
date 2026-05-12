class ModerationJob < ApplicationJob
  queue_as :default
  def perform(micropost_id)
    micropost = Micropost.find(micropost_id)

    micropost.update(processing_state: :processing)
    broadcast(micropost)

    spam = TextModerationApi.check(:spam, micropost.content)

    micropost.update(
      spam_score: spam["score"],
      status: spam["label"]
    )

    broadcast(micropost)

    angry = TextModerationApi.check(:angry, micropost.content)

    micropost.update(
      is_angry: angry["moderation"]["is_angry"],
      angry_score: angry["moderation"]["score"],
      reason: angry["moderation"]["reason"],
      summary: angry["summary"],
      processing_state: :done
    )

    broadcast(micropost)
  end

  private
  def broadcast(micropost)
    Turbo::StreamsChannel.broadcast_replace_to(
      "microposts",
      target: "status-#{micropost.id}",
      partial: "microposts/poststatus",
      locals: { micropost: micropost }
    )
  end
end
