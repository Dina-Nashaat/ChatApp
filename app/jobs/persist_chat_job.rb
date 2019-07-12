class PersistChatJob < ApplicationJob
  queue_as :chats

  def perform(chat_params)
    # TODO handle errors:
    # Check if Application persisted
    Chat.create(chat_params)
    sleep(5)
  end
end
