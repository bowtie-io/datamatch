class Project < ActiveRecord::Base

  self.primary_key = 'sid'

  has_and_belongs_to_many :users, join_table: :projects_users
  has_many :matches
  has_many :details

  before_create :generate_sid

  private
  def generate_sid
    self.sid = "pr_"+SecureRandom.urlsafe_base64(6)
  end
end
