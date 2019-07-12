class PersistMessageJob < ApplicationJob
  queue_as :default

  def perform(message_params)
    Message.create(message_params)
  end
end
