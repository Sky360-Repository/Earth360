require "test_helper"

class TracksControllerTest < ActionDispatch::IntegrationTest
  fixtures :tracks
  fixtures :users

  test "should return a KML file with method nearby" do
    get request_track_url, params: { method: "NEARBY", radius: 1, units: "miles", latitude: 40.723309, longitude: -73.988448 }, headers: {}
    assert_response :success
    assert_equal "application/vnd.google-earth.kml+xml", response.content_type
    assert_equal "attachment; filename=\"track.kml\"; filename*=UTF-8''track.kml", response.headers["Content-Disposition"]
  end

  test "should return a KML file with method random" do
    get request_track_url, params: { method: "RANDOM" }, headers: {}
    assert_response :success
    assert_equal "application/vnd.google-earth.kml+xml", response.content_type
    assert_equal "attachment; filename=\"track.kml\"; filename*=UTF-8''track.kml", response.headers["Content-Disposition"]
  end

  test "should create a user track" do
    assert_difference("UserTrack.count") do
      get request_track_url, params: { method: "NEARBY", radius: 1, units: "miles", latitude: 40.723309, longitude: -73.988448 }, headers: {}
    end
  end
end
