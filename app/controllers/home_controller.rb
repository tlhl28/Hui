class HomeController < ApplicationController

  def timeline
	@flowing = []
	@flowing << @user.waves.in()
	@flowing << @user.waves.out()
	@flowing.sort()
	render timeline
  end

  def profile
	@flowing = []
	@flowing << @user.waves.out()
	render profile
  end

  def sign_up
	new_user = User.new
	if request.post?
	  if simple_captcha_valid?
		new_user = User.new(params[:new_user])
		if new_user.save
		  notice_stickie t(:message_1, :scope => [:txt, :controller, :blog])
		  redirect_to login_path
		end
	  else
		new_user = User.new(params[:new_user])
		error_stickie t(:message_2, :scope => [:txt, :controller, :blog])
	  end
	end
  end

  def login
	if request.get?
	  session[:jump] = params[:jump]
	elsif request.post?
	  user = User.login(params[:name], params[:password])
	  if user
		jump = session[:jump]
		_clean_session_cookie
		#user.set_session(session, request, @site)
		_set_user_session(user)
		#remember me
		cookies[:remember_key] = user.remember_me() if params[:persist]
		if jump
		  redirect_to(jump)
		else
		  error_stickie t(:message_3, :scope => [:txt, :controller, :blog])
		end
	  end
	end  
  end

  def logout
	reset_session
	_clean_session_cookie 
	notice_stickie t(:message_0, :scope => [:txt, :controller, :application])
	redirect_to login_path
  end

  def forgot_password
	return unless request.post?
	user = User.find_by_email(params[:email])
	if user
	  #TODO
	  user.forgot_password(request)
	  notice_stickie t(:reset_password_email_send, :scope => [:txt, :controller, :blog])
	else
	  error_stickie t(:no_user_found, :scope => [:txt, :controller, :blog])
	end
  end

  def reset_password
	return unless request.post?
	user = User.find_by_reset_password_key(params[:key])
	if user && user.reset_password_key_expires_at > Time.now
	  if params[:new] == params[:_new]
		user.password = params[:new]
		user.reset_password_key = nil
		user.save
		notice_stickie t(:password_reseted, :scope => [:txt, :controller, :blog])
	  else
		error_stickie t(:confirm_dismatch, :scope => [:txt, :controller, :blog])
	  end    
	else
	  error_stickie t(:reset_password_expired, :scope => [:txt, :controller, :blog])
	end 
  end

end 
