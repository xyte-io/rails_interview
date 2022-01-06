class Comment < ApplicationRecord
  belongs_to :user

  validates_presence_of :content

  def as_json(options = {})
    {
      id: id,
      content: content,
      user: user.as_json
    }
  end
end
