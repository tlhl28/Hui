class StatusesController < ApiController

  def friends_timeline
	@user = User.find(4)
	waves = @user.follows.collect do |follow| 
	  follow.fresh_waves.to_a
	end
	waves += @user.waves_except(Flowing::SHARE).to_a.sort
	waves.flatten!
	waves.sort_by { |wave| wave.created_at }
	to_api(waves)
  end

  def user_timeline
	#@user = User.find_by_name("me")
	@user = User.find 4
	waves = @user.fresh_waves.to_a
	to_api(waves)
  end

  def update
	wave = Wave.new(param[:wave])
	@user.waves << wave
	to_api(wave) if @user.save
  end

  def destroy
	render "destroy"
  end

  def show
	render "show"
  end
end
