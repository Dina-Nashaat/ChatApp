class PersistChatJob < ApplicationJob
  queue_as :chats

  def perform(chat, application, action)
    action == 'create' && Chat.create(chat)
    if action == 'delete'
      chat.deleted = true
      chat.save
    end
    CountChatsJob.perform_later application
  end
end
