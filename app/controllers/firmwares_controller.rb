class FirmwaresController < ApplicationController
  def index
    @firmwares = Firmware.all
  end

  def new
    @firmware = Firmware.new
  end

  def create
    @firmware = Firmware.new(firmware_params)
    if @firmware.save
      redirect_to action: "index"
    else
      render 'new'
    end
  end

  def delete
    @firmware = Firmware.find(params[:firmware_id])
    @firmware.destroy
    redirect_to action: "index"
  end

  private

    def firmware_params
      params.require(:firmware).permit(:file)
    end
end
