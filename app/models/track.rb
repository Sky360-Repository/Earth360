class Track < ApplicationRecord
    has_many :tracks, dependent: :destroy
    def self.near(latitude, longitude, radius, units: :kilometers)
        return self.none if latitude.nil? || longitude.nil? || radius.nil? || radius <= 0
        return self.none if units != :kilometers && units != :miles

        # Convert radius to meters, as st_dwithin expects meters
        radius *= 1000 if units == :kilometers
        radius *= 1609.34 if units == :miles

        # Use the ST_DWithin PostGIS function to find tracks within a radius

        self.where("ST_DWithin(start, ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326), :radius)", {latitude: latitude, longitude: longitude, radius: radius})
    end
end
