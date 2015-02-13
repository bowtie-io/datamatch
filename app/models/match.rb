class Match < ActiveRecord::Base
  belongs_to :project
  belongs_to :user


  before_create :generate_sid

  private
  def generate_sid
    self.sid = "mtc_"+SecureRandom.urlsafe_base64(6)
  end


end
