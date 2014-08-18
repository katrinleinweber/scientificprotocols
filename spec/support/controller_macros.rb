module ControllerMacros
  def login_user
    before(:each) do
      @current_user = FactoryGirl.create(:user)
      session[:user_id] = @current_user.id
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:access_token] = Rails.configuration.api_github
    end
  end
end