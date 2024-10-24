# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :assign_role, only: [:create]

  protected

  # Allow extra sign-up parameter `author`
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [])
  end

  # Assign the role based on the checkbox
  def assign_role
    if params[:author] == "1" # Checkbox returns "1" when checked
      params[:user][:role] = "author"
    else
      params[:user][:role] = "guest"
    end
  end
end
