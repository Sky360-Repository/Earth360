class RenameUserTracksIdToUserTrackId < ActiveRecord::Migration[7.2]
  def change
    # Rename the column in the finds table
    rename_column :finds, :user_tracks_id, :user_track_id
  end
end
