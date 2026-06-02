module ApplicationHelper
  def full_title(page_title = "")
    base_title = t("app.base_title")
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # 現在のページに対応するヘルプパーシャルのキー（例: "users_show"）
  def help_partial_key
    "#{controller_name}_#{action_name}"
  end

  # 対応する本文パーシャルが存在すればそれを、無ければ default を返す
  def help_partial_path
    if lookup_context.exists?(help_partial_key, [ "shared/help" ], true)
      "shared/help/#{help_partial_key}"
    else
      "shared/help/default"
    end
  end

  # モーダルの見出し。未定義のページは汎用タイトルにフォールバック
  def help_title
    t("help.titles.#{help_partial_key}", default: t("help.modal_title"))
  end

  # フォーム項目に入力条件がある場合、ラベル横に小さく表示する。
  # helpers.hint.<model>.<attr> が定義されていない項目は何も出力しない。
  def label_hint(form, attribute)
    model_key = form.object.model_name.i18n_key
    text = t("helpers.hint.#{model_key}.#{attribute}", default: "")
    return "" if text.blank?

    content_tag(:small, "（#{text}）", class: "form-text text-muted ms-1")
  end
end
