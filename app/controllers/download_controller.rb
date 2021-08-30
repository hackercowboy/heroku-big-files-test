class DownloadController < ActionController::Base
  include ActionController::Live

  def stream
    @firmware = Firmware.find(params[:firmware_id])

    response.headers['Content-Type'] = @firmware.file.content_type
    response.headers['Content-Disposition'] = ContentDisposition.format(disposition: 'attachment', filename: @firmware.file.filename.to_s)

    # Without this header something is loading the hole active storage blob into memory. Caching?
    response.headers["Last-Modified"] = Time.zone.now.ctime.to_s

    @firmware.file.download do |chunk|
      response.stream.write(chunk)
    end
  ensure
    response.stream.close
  end
end
