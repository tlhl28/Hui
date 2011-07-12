class HomeController < ApplicationController
  def timeline

  end

  def login
    if request.get?
      session[:jump] = params[:jump]
    elsif request.post?
      user = User.login(params[:name], params[:password])
      if user
        jump = session[:jump]
        clean_session_cookie
        #user.set_session(session, request, @site)
        #user.remember_me(cookies, request) if params[:persist]
        if jump
          redirect_to(jump)
        else
          error_stickie t(:message_3, :scope => [:txt, :controller, :blog])
        end
      end
    end  
  end

  def forgot_password
    return unless request.post?
    user = User.find_by_email(params[:email])
    if user
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
