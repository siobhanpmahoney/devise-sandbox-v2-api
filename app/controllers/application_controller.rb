class ApplicationController < ActionController::API

  def encode_token(payload)
    JWT.encode(payload, secret, algorithm)
  end

  def login_user(username, password)

    user = User.find_by(username: username)
    if user && user.authenticate(password)
      user
    else
      raise AuthError
    end
  end

  def authorize_user!
    if !current_user.present?
      render json: {error: 'No user id present'}
    end
  end

  def authorized
    render json: { message: "Please login" }, status: :unauthorized unless logged_in?
  end


  def current_user
    if @current_user
      @current_user
    elsif decode_token
      user_id = decode_token[0]['user_id']
      @current_user = User.find_by(id: user_id)
    end
  end

  def site_admin?
    current_user.admin
  end

  def logged_in?
    !!current_user
  end



  def decode_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, secret, true, { algorithm: algorithm })
      rescue JWT::DecodeError
        nil
      end

    end
  end



    def auth_header
      request.headers['Authorization']
    end

    def secret
      Rails.application.secrets.secret_key_base # replaced 'placeholder' with actual secret key
    end

    def algorithm
      'HS256'
    end

    class AuthError < StandardError
      def initialize(message="Invalid User or password")
        super
      end
    end

    class RequestPasswordResetError < StandardError
      def initalize(message="Email address not found. Please contact your ")
        super
      end
    end

    class CreateError < StandardError
      def initialize(message="Error - item not created")
        super
      end
    end

  end
