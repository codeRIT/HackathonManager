require 'test_helper'

class Manage::AgreementsControllerTest < ActionController::TestCase
  setup do
    @agreement = create(:agreement)
  end

  context "while not authenticated" do
    should "redirect to sign in page on manage_agreements_#index" do
      get :index, format: :json
      assert_response :unauthorized
    end

    should "not allow access to manage_agreements#create" do
      post :create, params: { agreement: { name: "Fun Agreement", agreement_fun: "https://bar.edu" } }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_agreements#update" do
      patch :update, params: { id: @agreement, agreement: { name: "Not fun agreement" } }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_agreements#destroy" do
      patch :destroy, params: { id: @agreement }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end
  end

  context "while authenticated as a user" do
    setup do
      @user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_agreements#index" do
      get :index, format: :json
      assert_response :redirect
    end

    should "not allow access to manage_agreements#create" do
      post :create, params: { agreement: { name: "Fun Agreement", agreement_fun: "https://bar.edu" } }
      assert_response :redirect
    end

    should "not allow access to manage_agreements#update" do
      patch :update, params: { id: @agreement, agreement: { name: "Not fun agreement" } }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_agreements#destroy" do
      patch :destroy, params: { id: @agreement }
      assert_response :redirect
      assert_redirected_to root_path
    end
  end

  context "while authenticated as a volunteer" do
    setup do
      @user = create(:volunteer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_agreements#index" do
      get :index
      assert_response :unauthorized
    end

    should "not allow access to manage_agreements#create" do
      post :create, params: { agreement: { name: "Fun Agreement", agreement_fun: "https://bar.edu" } }
      assert_response :redirect
      assert_redirected_to manage_agreements_path
    end

    should "not allow access to manage_agreements#update" do
      patch :update, params: { id: @agreement, agreement: { name: "Not fun agreement" } }
      assert_response :redirect
      assert_redirected_to manage_agreements_path
    end

    should "not allow access to manage_agreements#destroy" do
      patch :destroy, params: { id: @agreement }
      assert_response :redirect
      assert_redirected_to manage_agreements_path
    end
  end

  context "while authenticated as an organizer" do
    setup do
      @user = create(:organizer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_agreements#index" do
      get :index, format: :json
      assert_response :redirect
    end

    should "not allow access to manage_agreements#create" do
      post :create, params: { agreement: { name: "Fun Agreement", agreement_fun: "https://bar.edu" } }
      assert_response :redirect
    end

    should "not allow access to manage_agreements#update" do
      patch :update, params: { id: @agreement, agreement: { name: "Not fun agreement" } }
      assert_response :redirect
      assert_redirected_to manage_agreements_path
    end

    should "not allow access to manage_agreements#destroy" do
      patch :destroy, params: { id: @agreement }
      assert_response :redirect
      assert_redirected_to manage_agreements_path
    end
  end

  context "while authenticated as a director" do
    setup do
      @user = create(:director)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "allow access to manage_agreements#index" do
      get :index, format: :json
      assert_response :ok
    end

    should "create a new agreement" do
      post :create, params: { agreement: { name: "Fun Agreement", agreement: "Please read and accept https://foo.com" } }
      assert_response :ok
    end

    should "update agreement" do
      patch :update, params: { id: @agreement, agreement: { name: "New agreement Name" } }
      assert_response :ok
    end

    context "#destroy" do
      should "destroy agreement" do
        assert_difference("Agreement.count", -1) do
          patch :destroy, params: { id: @agreement }
        end
        assert_response :ok
      end
    end
  end
end
