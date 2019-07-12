class Message < ApplicationRecord
  after_save :searchkick_indexing
  searchkick text_middle: [:content]
  
  acts_as_tenant(:application)
  belongs_to :chat

  scope :active, -> { where(deleted: false) }

  def search_data
    {
      content: content,
      chat_id: chat_id
    }
  end

  def searchkick_indexing
  end

end
