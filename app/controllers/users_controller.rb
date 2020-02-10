class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :set_one_month, only: [:show]

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
    @first_day = Date.current.beginning_of_month
    @last_day = @first_day.end_of_month
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
      flash[:success] = "新規作成に成功しました。"
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
    
    def user_params  
      params.require(:user).permit(:name, :email,:department, :password, :password_confirmation)
    end
    
    # beforeフィルター
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_path
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user(@user)
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end