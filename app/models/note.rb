# Note represents a note in the system. It is associated with a User
# and can be tagged with one or more Tag objects.
#
# A Note has the following required fields:
# * title (from 3 to 250 characters)
# * body (must be present)
#
class Note < ActiveRecord::Base

  acts_as_taggable

  belongs_to :user

  validates :title, length: { in: 3..250 }
  validates :body, presence: true

  scope :deleted, -> { where(deleted: true) }
  scope :visible, -> { where(deleted: false) }

  # Mare a note as shared by populating the "slug" attribute.
  # Does not modify the database. Explicitly call Note#save to do that.
  def share
    self.slug  = SecureRandom.urlsafe_base64
  end

  # Marks a note as unshared by removing the "slug" attribute.
  # Does not modify the database. Explicitly call Note#save to do that.
  def unshare
    self.slug = nil
  end

  # Locate notes by keyword query, looking for any occurance of the keyword
  # in the title or body of the note. Ignores case.
  def self.find_all_by_keyword(query)
    query = "%#{query}%"

    Note.visible.where(["lower(title) like ? OR
                         lower(body) like ?",
                         query, query])

  end
end
