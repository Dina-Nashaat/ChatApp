class ApplicationsController < ApplicationController
  skip_before_action :find_and_set_tenant, only: [:create]
  before_action :set_application, only: [:update, :destroy, :index]

  def index
    render json: serialized_application(@application)
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      render json: serialized_application(@application), status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  def update
    if @application.update(application_params)
      render json: serialized_application(@application)
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @application.deleted = true
    @applitcation.save
  end

  private
    def serialized_application(response)
      response.to_json(only: [:access_token, :name, :chats_count])
    end

    def application_params
      params.require(:application).permit(:name)
    end

    def set_application
      @application = ActsAsTenant.current_tenant
    end

    def redis_hash_key
      'applications'
    end
end
