class Match < ActiveRecord::Base
  def left_profile_id           ; super end
  def right_profile_id          ; super end
  def left_profile_matched_at   ; super end
  def right_profile_matched_at  ; super end
  def left_profile_notified_at  ; super end
  def right_profile_notified_at ; super end

  belongs_to :left_profile,  class_name: 'Profile'
  belongs_to :right_profile, class_name: 'Profile'

  validates :left_profile_id, presence: true
end
