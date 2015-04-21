class Detail < ActiveRecord::Base
    self.primary_key = 'sid'
    before_create :generate_sid

    belongs_to :project
    belongs_to :user


    private
    def generate_sid
      self.sid = "det_"+SecureRandom.urlsafe_base64(6)
    end
end
