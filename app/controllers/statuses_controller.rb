class StatusesController < ApiController

  def friends_timeline
	waves = @user.follows.collect do |follow| 
	  follow.fresh_waves
	end
	waves << @user.waves_except(Flowing::SHARE).sort
	waves.sort_by { |wave| wave.created_at }

	to_api(waves)
  end

  def user_timeline
	waves = @user.fresh_waves

	to_api(waves)
  end

  def update
	wave = Wave.new(param[:wave])
	@user.waves << wave
	to_api(wave) if @user.save
  end

  def destroy
  end

  def show
  end
end
