class ModerationJob < ApplicationJob
  queue_as :default

  def perform(micropost_id)
    micropost = Micropost.find(micropost_id)
    micropost.update!(processing_state: :processing)
    broadcast(micropost)

    apply_spam_result(micropost)
    broadcast(micropost)

    apply_angry_result(micropost)
    micropost.update!(processing_state: :done)
    broadcast(micropost)
  rescue => e
    micropost&.update(processing_state: :failed)
    raise e
  end

  private

    def apply_spam_result(micropost)
      result = TextModerationApi.check(:spam, micropost.content)
      micropost.update!(
        spam_score: result["score"],
        status:     result["label"]
      )
    end

    def apply_angry_result(micropost)
      result = TextModerationApi.check(:angry, micropost.content)
      moderation = result["moderation"]
      micropost.update!(
        is_angry:    moderation["is_angry"],
        angry_score: moderation["score"],
        reason:      moderation["reason"],
        summary:     result["summary"]
      )
    end

    def broadcast(micropost)
      Turbo::StreamsChannel.broadcast_replace_to(
        "microposts",
        target:  "status-#{micropost.id}",
        partial: "microposts/poststatus",
        locals:  { micropost: micropost }
      )
    end
end
