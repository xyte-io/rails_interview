class User < ApplicationRecord
  has_many :comments

  validates_presence_of :name, :email

  def as_json(options = {})
    {
      id: id,
      name: name,
      email: email
    }
  end
end
