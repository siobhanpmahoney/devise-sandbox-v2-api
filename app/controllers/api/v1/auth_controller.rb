class Api::V1::AuthController < ApplicationController

  # skip_before_action :authorized, only: [:login, :signup, :currentUser]

  def login
   begin
     @user = login_user(params[:username], params[:password])

     # if user && !user.activated?
     #   user.update_attribute(:activated, true)
     #   user.update_attribute(:activated_at, Time.zone.now)
     # end

     if user && user.authenticate(params[:password])
      @token = encode_token({ user_id: user.id })

      render json: { user: @user, token: @token }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end




   rescue AuthError => e
     render json: { error: e.message }, status: 401
   end
  end

  def currentUser
    user = current_user
   if user

     render json: {
       id: user.id,
       username: user.username }
   else
     render json: nil
   end
  end

def signup
  user = User.new(user_params)
  user.password = create_secure_password
  if user.save
    begin
      user = login_user(user_params[:username], user.password)
      render json: {
        id: user.id,
        username: user.username,
        token: encode_token({'user_id': user.id})
      }

    rescue AuthError => e
      render json: { error: "Invalid Passwords"}, status: 401
    end
  else
    render json: { error: "Need all info correct to sign up" }
  end

end

private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def create_secure_password
    SecureRandom.hex(10)
  end

end
