class TracksController < ApplicationController
    before_action :authenticate_user!

    def request_track
        method = params[:method]
        if method == "NEARBY"
            radius = params[:radius].to_f
            units = params[:units].downcase.strip.to_sym
            if units == :miles
                radius *= 1.60934 # convert miles to kilometers
            end
            selected_track = Track.near(params[:latitude], params[:longitude], radius, units: units).limit(1).first
        else
            selected_track = Track.order("RANDOM()").limit(1).first
        end
        start_longitude = selected_track.start.x
        start_latitude = selected_track.start.y
        end_longitude = selected_track.end.x
        end_latitude = selected_track.end.y
        kml_data = <<-KML
            <?xml version="1.0" encoding="UTF-8"?>
            <kml xmlns="http://www.opengis.net/kml/2.2">
            <Document>
                <Placemark>
                <name>Line Between Points</name>
                <LineString>
                    <coordinates>
                    #{start_longitude},#{start_latitude},0
                    #{end_longitude},#{end_latitude},0
                    </coordinates>
                </LineString>
                </Placemark>
            </Document>
            </kml>
        KML
        UserTrack.create(user: current_user, track: selected_track, requested_at: Time.now)
        send_data kml_data, filename: "track.kml", type: "application/vnd.google-earth.kml+xml", disposition: "attachment"
    end
end
