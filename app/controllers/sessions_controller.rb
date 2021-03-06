require 'date'

class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']
    # raise
    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])


    if user
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as TEST ROUTE"
    else
      new_user = User.new(
        username: auth_hash['info']['nickname'],
        email: auth_hash['info']['email'],
        uid: auth_hash['uid'],
        provider: auth_hash['provider'],
        created_at: Time.now
      )

      if new_user.save
        session[:user_id] = new_user.id
        flash[:success] = "Successfully logged in"
      else
        flash[:error] = "Could not log in"
        redirect_to root_path
        return
      end
    end
    redirect_to root_path

  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end






  # def login_form
  # end
  #
  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end
  #
