class CreateUserTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :user_tracks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.timestamp :requested_at, null: false
      t.timestamp :completed_at
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
