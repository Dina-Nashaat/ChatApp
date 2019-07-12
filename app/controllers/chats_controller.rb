class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:destroy]

  def index
    # Chat.All is scoped by tenant
    render json: serialized_chat(Chat.active)
  end

  def create
    PersistChatJob.perform_later chat
    CountChatsJob.perform_later @application
    render json: serialized_chat(chat), status: :created
  end

  def destroy
    @chat.deleted = true
    @chat.save
    CountChatsJob.perform_later @application
  end

  private
    def chat
      { number: number, application: @application }
    end
    
    def serialized_chat(response)
      response.to_json(only: [:number, :messages_count])
    end

    def number
      @number ||= $redis.hincrby redis_hash_key, @application.access_token, 1
    end

    def set_application
      @application ||= ActsAsTenant.current_tenant
    end

    def set_chat
      @chat |= Chat.active.find(params[:number])
    end

    def redis_hash_key
      'applications'
    end
end
