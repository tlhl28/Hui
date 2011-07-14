class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :_authorize

  private

  def _set_user_session(user)
	session[:user_id] = user._id.to_s
	session[:user_name] = user.name
	session[:user_nick] = user.nick
	#session[:email] = user.email
  end

  def _authorize
	if session[:user_id]
	  @user = User.find(session[:user_id])
	  return if @user
	end
	if cookies[:remember_key] 
	  @user = User.find_by_remember_key(cookies[:remember_key])
	  if @user && @user.remember_key_expires_at > Time.now
		_set_user_session(user)
		return
	  end
	end
	redirect_to(login_path(:subdomain => "www"))
  end


  def _clean_session_cookie
	cookies.delete :remember_key 
	@user.update_attribute(:remember_key, "") if @user
  end

end
