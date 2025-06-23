class DashboardController < ApplicationController
    before_action :authenticate_user!

    def show
        @tracks = UserTrack.include(:track).where(user: current_user)
    end
end
