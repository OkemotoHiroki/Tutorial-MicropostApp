module MicropostsHelper
  # ポストの表示可否
  def visible_to_user?(post, current_user)
    return true if current_user.admin?
    return true if post.user_id == current_user.id
    post.status != "danger"
  end

  # スパム度の表示
  def spam_score_percentage(score)
    return nil if score.nil?
    (score * 100).round(2)
  end

  # 状態ラベル
  def micropost_status_label(status)
    case status
    when "safe" then "✅安全"
    when "warning" then "⚠️注意"
    when "danger" then "🚨危険"
    end
  end

  # CSSクラス
  def micropost_status_class(status)
    case status
    when "safe" then "text-success"
    when "warning" then "text-warning"
    when "danger" then "text-danger"
    end
  end
end
