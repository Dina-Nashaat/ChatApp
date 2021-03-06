class PersistMessageJob < ApplicationJob
  queue_as :default

  def perform(message, chat, action)
    action == 'create' && Message.create(message)
    if action == 'delete'
      message.deleted = true
      message.save
    end
    Message.reindex(async: true)
    CountMessagesJob.perform_later chat
  end
end
