class CreateFirmwares < ActiveRecord::Migration[6.1]
  def change
    create_table :firmwares do |t|
      t.timestamps
    end
  end
end
