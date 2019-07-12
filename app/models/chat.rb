class Chat < ApplicationRecord
  acts_as_tenant(:application)
  has_many :messages
  scope :active, -> { where(deleted: false) }

end
