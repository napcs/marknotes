# A User can log into the system and own notes.
#
# A User has many Tag objects as well, by going through the Note object. This
# makes it possible to find all tags for a user with
#
#     user.tags
#
# Most of the functionality of User is provided by Devise.
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :notes
  has_many :tags, through: :notes
end
