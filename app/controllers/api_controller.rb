class ApiController < ActionController::Base
  protect_from_forgery

  def to_api(data)
	respond_to do |format|
	  format.json { render :json => data }
	  format.xml { render :xml => data }
	end
  end

end
