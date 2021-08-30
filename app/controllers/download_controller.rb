class DownloadController < ApplicationController
  include ActionController::Live

  def download
    @firmware = Firmware.find(params[:firmware_id])
    response.headers['Content-Type'] = @firmware.file.content_type
    response.headers['Content-Disposition'] = ContentDisposition.format(disposition: 'attachment', filename: @firmware.file.filename.to_s)
    response.headers['X-Accel-Buffering'] = 'no'
    @firmware.file.download do |chunk|
      response.stream.write(chunk)
    end
  ensure
    response.stream.close
  end
end
