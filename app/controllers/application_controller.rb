class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  
  private

  def logout_and_redirect_to
	reset_session
	clean_session_cookie 
	notice_stickie t(:message_0, :scope => [:txt, :controller, :application])
	redirect_to login_path
  end

  def clean_session_cookie
	cookies.delete :remember_key 
	@user.update_attribute(:remember_key, "")
  end

  def require_login
	unless logged_in?
	  flash[:error] = "You must be logged in to access this section"
	  redirect_to login_url # halts request cycle
	end
  end

  # The logged_in? method simply returns true if the user is logged
  # in and false otherwise. It does this by "booleanizing" the
  # current_user method we created previously using a double ! operator.
  # Note that this is not common in Ruby and is discouraged unless you
  # really mean to convert something into true or false.
  def logged_in?
	!!current_user
  end

  # Finds the User with the ID stored in the session with the key
  # :current_user_id This is a common way to handle user login in
  # a Rails application; logging in sets the session value and
  # logging out removes it.
  def current_user
	@_current_user ||= session[:current_user_id] &&
	  User.find(session[:current_user_id])
  end

end
