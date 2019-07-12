class ApplicationController < ActionController::API
  set_current_tenant_through_filter
  before_action :find_and_set_tenant
  
  def find_and_set_tenant
    @errors = {}
    request_token = auth_header
    current_app = current_application(request_token) if request_token    
    set_current_tenant(current_app) if current_app
    if !@errors.empty?
      render json: @errors, status: :unprocessable_entity
      return
    end
  end  

  def auth_header
    return request.headers['Authorization'] if request.headers['Authorization'].present?
    @errors[:token] =  'Missing token'
    return nil
  end

  def current_application(token)
    puts token
    application = Application.find_by(access_token: token)
    return application if application
    @errors[:token] = 'Invalid token' if !application
    return nil
  end

  def generate_incremental_number
  end
end
