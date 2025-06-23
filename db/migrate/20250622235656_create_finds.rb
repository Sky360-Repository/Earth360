class CreateFinds < ActiveRecord::Migration[7.2]
  def change
    create_table :finds do |t|
      t.references :user_tracks, null: false, foreign_key: true
      t.st_point :location, geographic: true

      t.timestamps
    end
  end
end
