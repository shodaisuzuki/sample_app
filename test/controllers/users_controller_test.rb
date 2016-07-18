require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	def setup
		@user = users(:michael)
		@other_user = users(:archer)
	end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "shouls redirect edit when not logged in" do
  	get :edit, id: @user
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "shouls redirect update when not logged in" do
  	patch :update, id: @user, user: { name: @user.name, email: @user.email }
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
  	log_in_as(@other_user) #other_userでlogin
  	get :edit, id: @user #userのeditページを指定
  	assert flash.empty? #flash出てないならtrue
  	assert_redirected_to root_url #違うユーザーなので失敗-> root_urlへ移動される
  end

  test "should redirect update when logged in as wrong user" do
  	log_in_as(@other_user)
  	patch :update, id: @user, user: { name: @user.name, email: @user.email } #userのnameとemailが対象
  	assert flash.empty? #flash出てないならtrue
  	assert_redirected_to root_url #違うユーザーなので失敗-> root_urlへ移動される
  end

  test "should redirect destroy when not logged in" do
    #@userを削除する命令を出しても消えてない（userの数は変わってない）
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    #@userを削除する命令を出しても消えてない（userの数は変わってない）
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

end
