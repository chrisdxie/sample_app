# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
	ids = "SELECT followed_id FROM Relationships WHERE follower_id = :user_id"
	Micropost.where("user_id IN (#{ids}) OR user_id = :user_id", 
					user_id: user.id)
  end

end
