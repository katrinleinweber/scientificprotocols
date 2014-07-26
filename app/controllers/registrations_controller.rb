class RegistrationsController < Devise::RegistrationsController
  # By default devise does not allow the user to edit their account with a password
  # confirmation. Overriding this behavior here as users who signed up with oAuth won't know
  # their password making for a clumsy experience.
  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # Required for settings form to submit when password is left blank.
    if account_update_params[:password].blank?
      account_update_params.delete('password')
      account_update_params.delete('password_confirmation')
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed.
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end
end