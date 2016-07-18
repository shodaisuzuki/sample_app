class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #index,edit,update,destroyコントローラーのみ適用
  before_action :correct_user, only: [:edit, :update] #edit,updateコントローラーのみ適用
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation) #adminはアクセスの許可をしない
  	end

    #beforeフィルター

    #ログイン済みのユーザーかどうか確認
    def logged_in_user
      unless logged_in? #ログインしてないとき
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url #login画面へ移動させる
      end
    end

    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
            redirect_to(root_url) unless current_user?(@user)
            #現在のユーザーと引数のユーザーが違うときroot_urlに移動させる
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
      #現在のユーザーが管理者じゃなければroot_urlに移動させる
    end

end
