class HomeController < ActionController::Base

  def index
    render json: {message: 'Hello!'}
  end
end

