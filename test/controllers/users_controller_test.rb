require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper
  setup do
    @user = create(:user)
  end

  should "allow access to user#get" do
    sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    get :show, params: { format: :json }
    assert_response :success
  end

  should "don't allow user#show if not signed in" do
    get :show, params: { format: :json }
    assert_response(:unauthorized)
  end
end
