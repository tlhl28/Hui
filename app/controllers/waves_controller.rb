class WavesController < ApplicationController

  def new
	@user.follower.each do |id|
	  follower = User.find(id)
	  wave = Waves.new(:audio => param[:audio_id])
	  follower.waves.flow_in(wave)
	end
	@user.waves.flow_out(wave)
  end

  def destroy(id)
	Waves.destroy(id)
  end

end
