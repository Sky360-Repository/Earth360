AdminUser.find_or_create_by!(email: 'admin@example.com') if Rails.env.development?

archive_path = Rails.root.join('db', 'fixtures', '240727_Trajectories_50km.tar.gz').to_s
tracks_path = Rails.root.join('db', 'fixtures', '240727_Trajectories_50km.csv').to_s
chunk_size = 100000

# extract the archive to a csv on disk, then open it, you need tar and gzip installed
system("tar -xvzf #{archive_path} -C #{File.dirname(archive_path)}")

puts "successfully extracted archive"
puts "Importing tracks..."

# Clean up the imported table before run
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS tracks_import")

# Import the tracks
sql = <<~SQL
  CREATE TABLE IF NOT EXISTS tracks_import (
     start_latitude double precision,
     start_longitude double precision,
     stop_latitude double precision,
     stop_longitude double precision
  );
  COPY tracks_import ("start_latitude", "start_longitude", "stop_latitude", "stop_longitude") FROM '#{tracks_path}' DELIMITERS ',' CSV HEADER;
SQL

puts sql

# Execute the raw SQL
puts ActiveRecord::Base.connection.execute(sql)

puts "Moving tracks to the tracks table..."

# Move the imported tracks to the tracks table
puts 'INSERT INTO tracks ("start", "end", "created_at", "updated_at") SELECT ST_SetSRID(ST_MakePoint(start_longitude, start_latitude), 4326), ST_SetSRID(ST_MakePoint(stop_longitude, stop_latitude), 4326), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM tracks_import;'

# Execute the raw SQL
ActiveRecord::Base.connection.execute('INSERT INTO tracks ("start", "end", "created_at", "updated_at") SELECT ST_SetSRID(ST_MakePoint(start_longitude, start_latitude), 4326), ST_SetSRID(ST_MakePoint(stop_longitude, stop_latitude), 4326), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM tracks_import;')

puts "cleaning up tracks import table..."

# Clean up the imported table
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS tracks_import")

puts "Imported #{Track.count} tracks"

# Clean up the extracted csv
puts "cleaning up extracted csv..."
system("rm -rf #{tracks_path}")
