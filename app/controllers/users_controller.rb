class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :index, :edit, :update, :destroy, :following, :followers ]
  before_action :set_user,       only: [ :show, :edit, :update, :destroy, :following, :followers ]
  before_action :correct_user,   only: [ :edit, :update ]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t("flash.users.create_success")
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t("flash.users.update_success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @users = User.activated.paginate(page: params[:page])
  end

  def destroy
    @user.destroy
    flash[:success] = t("flash.users.destroy_success")
    redirect_to users_url
  end

  def following
    @title = t("users.relationships.following")
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t("users.relationships.followers")
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
