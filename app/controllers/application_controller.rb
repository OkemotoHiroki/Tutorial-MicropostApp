class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include SessionsHelper
  def hello
    render html: "hello,world!"
  end

  private
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t("flash.login_required")
        redirect_to login_url
      end
    end
end
