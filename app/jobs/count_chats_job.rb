class CountChatsJob < ApplicationJob
  queue_as :default

  def perform(application)
    application.update(chats_count: application.chats.count)
  end
end
