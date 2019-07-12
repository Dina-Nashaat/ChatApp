class MessagesController < ApplicationController
  before_action :set_chat, :set_application
  before_action :set_message, only: [:update, :destroy, :show]

  def index
    render json: serialized_message(@chat.messages.active)
  end

  def show
    render json: serialized_message(@message)
  end

  def create
    PersistMessageJob.perform_later message, @chat, :create
    render json: serialized_message(message), status: :created
  end

  def search
    @messages = Message.search(params[:term], where: { chat_id: [@chat.id] })
    render json: serialized_message(@messages)
  end

  def update
    if @message.update(message_params)
      render json: serialized_message(@message)
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    PersistMessageJob.perform_later message, @chat, :create
    render json: serialized_message(message), status: :created
  end

  private
    def message
      {
        content: message_params[:content], 
        application: @application,
        chat: @chat,
        number: number
      }
    end

    def message_params
      message = params.require(:message).permit(:content)
    end

    def serialized_message(response)
      response.to_json(only: [:number, :content])
    end

    def number
      @number ||= $redis.hincrby redis_key, redis_hash_key, 1
    end

    def set_application
      @application ||= ActsAsTenant.current_tenant
    end

    def set_chat
      @chat ||= Chat.find_by_number(params[:chat_number])
    end

    def set_message
      @message = Message.active.where(number: params[:number], chat: @chat)
    end

    def redis_key
      "chat_messages"
    end

    def redis_hash_key
      "#{@application.access_token}_#{@chat.number}"
    end
end
