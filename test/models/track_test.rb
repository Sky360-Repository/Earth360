require "test_helper"

class TrackTest < ActiveSupport::TestCase
  fixtures :tracks

  test "returns an empty relation if latitude is nil" do
    tracks = Track.near(nil, -73.988448, 10, units: :kilometers)
    assert_empty tracks
  end

  test "returns an empty relation if longitude is nil" do
    tracks = Track.near(40.723309, nil, 10, units: :kilometers)
    assert_empty tracks
  end

  test "returns an empty relation if radius is nil" do
    tracks = Track.near(40.723309, -73.988448, nil, units: :kilometers)
    assert_empty tracks
  end

  test "returns an empty relation if radius is less than or equal to 0" do
    tracks = Track.near(40.723309, -73.988448, 0, units: :kilometers)
    assert_empty tracks

    tracks = Track.near(40.723309, -73.988448, -1, units: :kilometers)
    assert_empty tracks
  end

  test "returns an empty relation if units is not :kilometers or :miles" do
    tracks = Track.near(40.723309, -73.988448, 10, units: :meters)
    assert_empty tracks
  end

  test "finds tracks within a radius in kilometers" do
    track = tracks(:one)
    tracks = Track.near(40, -73, 1000, units: :kilometers)
    assert_includes tracks, track
  end

  test "finds tracks within a radius in miles" do
    track = tracks(:one)
    tracks = Track.near(40, -73, 100, units: :miles)
    assert_includes tracks, track
  end
  
  test "returns rgeo point for start" do
    track = tracks(:one)
    track.start == RGeo::Geographic.spherical_factory(srid: 4326).point(-73.988448, 40.723309)
  end

  test "returns rgeo point for end" do
    track = tracks(:one)
    track.end == RGeo::Geographic.spherical_factory(srid: 4326).point(-73.988448, 40.723309)
  end
end
