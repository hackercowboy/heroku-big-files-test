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

  def download
    @firmware = Firmware.find(params[:firmware_id])
    response.headers['Content-Type'] = @firmware.file.content_type
    response.headers['Content-Disposition'] = ContentDisposition.format(disposition: 'attachment', filename: @firmware.file.filename.to_s)
    @firmware.file.download do |chunk|
      response.stream.write(chunk)
    end
  ensure
    response.stream.close
  end

  private

    def firmware_params
      params.require(:firmware).permit(:file)
    end
end
