class ApplicationController < ActionController::Base
  protect_from_forgery

  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: 'You are not authorized user to perform this action!' }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :type])
  end

  def not_found
    render json: {errors: ['Record Not Found']}, status: :not_found
  end
end
