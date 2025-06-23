class CreateTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :tracks do |t|
      t.st_point :start, geographic: true
      t.st_point :end, geographic: true

      t.timestamps
    end
  end
end
