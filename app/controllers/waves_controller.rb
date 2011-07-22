class WavesController < ApplicationController

  def new
	wave = Wave.new(param[:wave])
	@user.publish(wave)
  end

  def destroy(id)
	Wave.destroy(id)
  end

  def share(id)
  end

  def comment
  end

end
