class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    if current_user.present?
      render json: current_user, serializer: UserSerializer
    else
      return render json: {errors: [{message: 'User not found.'}]}, status: :unprocessable_entity
    end
  end
end
