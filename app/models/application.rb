class Application < ApplicationRecord
  has_secure_token :access_token
  has_many :chats
end
