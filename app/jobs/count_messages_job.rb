class CountMessagesJob < ApplicationJob
  queue_as :messages

  def perform(chat)
    chat.update(messages_count: chat.messages.count)
  end
end
