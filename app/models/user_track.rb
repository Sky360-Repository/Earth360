class UserTrack < ApplicationRecord
    has_many :finds, dependent: :destroy
    belongs_to :track
    belongs_to :user
    enum status: { pending: 0, completed: 1, failed: 2 }
end
