class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [ :create, :destroy ]
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t("flash.microposts.create_success")
      # Run moderation inline. On Render's free 512MB instance the in-Puma Solid Queue
      # worker is unusable (the puma plugin forks a second Rails process and dies with
      # "uninitialized constant SolidQueue"), so we execute synchronously. The job still
      # broadcasts its status via Turbo Streams, so the UI updates in real time over the
      # websocket. Errors are swallowed here (the job itself marks the post as failed) so a
      # moderation outage never blocks posting.
      begin
        ModerationJob.perform_now(@micropost.id)
      rescue => e
        Rails.logger.error("[ModerationJob] inline execution failed: #{e.class}: #{e.message}")
      end

      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home", status: :unprocessable_entity
    end
  end
  def destroy
    @micropost.destroy
    flash[:success] = t("flash.microposts.destroy_success")
    redirect_back(fallback_location: root_url, status: :see_other)
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
