module ControllerMacros
  def login_user(access_token = Rails.configuration.api_github)
    before(:each) do
      @current_user = FactoryGirl.create(:user)
      session[:user_id] = @current_user.id
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:access_token] = access_token
    end
  end
end