require 'test_helper'

class Manage::EventsControllerTest < ActionController::TestCase
  setup do
    @event = create(:event)
  end

  context "while not authenticated" do
    should "redirect to sign in page on manage_events#index" do
      get :index, format: :json
      assert_response :unauthorized
    end

    should "not allow access to manage_events#show" do
      get :show, params: { id: @event }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_events#create" do
      post :create, params: { event: { title: "should not exist title" } }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_events#update" do
      patch :update, params: { id: @event, title: "not allowed altered title" }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_events#destroy" do
      patch :destroy, params: { id: @event }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end
  end

  context "while authenticated as an user" do
    setup do
      @user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_events#index" do
      get :index, format: :json
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_events#show" do
      get :show, params: { id: @event }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_events#create" do
      post :create, params: { event: { title: "should not exist title" } }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_events#update" do
      patch :update, params: { id: @event, title: "not allowed altered title" }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_events#destroy" do
      patch :destroy, params: { id: @event }
      assert_response :redirect
      assert_redirected_to root_path
    end
  end

  context "while authenticated as an volunteer" do
    setup do
      @user = create(:volunteer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_events#index" do
      get :index
      assert_response :unauthorized
    end

    should "not allow access to manage_events#show" do
      get :show, params: { id: @event }
      assert_response :unauthorized
    end

    should "not allow access to manage_events#create" do
      post :create, params: { event: { title: "should not exist title" } }
      assert_response :redirect
      assert_redirected_to manage_events_path
    end

    should "not allow access to manage_events#update" do
      patch :update, params: { id: @event, title: "not allowed altered title" }
      assert_response :redirect
      assert_redirected_to manage_events_path
    end

    should "not allow access to manage_events#destroy" do
      patch :destroy, params: { id: @event }
      assert_response :redirect
      assert_redirected_to manage_events_path
    end
  end

  context "while authenticated as an organizer" do
    setup do
      @user = create(:organizer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "allow access to manage_events#index" do
      get :index, format: :json
      assert_response :success
    end

    should "not allow access to manage_events#show" do
      get :show, params: { id: @event }
      assert_response :redirect
      assert_redirected_to manage_root_path
    end

    should "not allow access to manage_events#create" do
      post :create, params: { event: { title: "should not exist title" } }
      assert_response :redirect
      assert_redirected_to manage_events_path
    end

    should "not allow access to manage_events#update" do
      patch :update, params: { id: @event, title: "not allowed altered title" }
      assert_response :redirect
      assert_redirected_to manage_events_path
    end

    should "not allow access to manage_events#destroy" do
      patch :destroy, params: { id: @event }
      assert_response :redirect
      assert_redirected_to manage_events_path
    end
  end

  context "while authenticated as an director" do
    setup do
      @user = create(:director)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "allow access to manage_events#index" do
      get :index, format: :json
      assert_response :success
    end

    should "allow access to manage_events#show" do
      get :show, params: { id: @event }, format: :json
      assert_response :success
    end

    should "allow access to manage_events#create" do
      post :create, params: { event: { title: "test new title", start: Date.today - 1.hour, finish: Date.today } }
      assert_response :ok
    end

    should "allow access to manage_events#update" do
      patch :update, params: { id: @event, event: { title: "test update title" } }
      assert_response :ok
    end

    should "allow access to manage_events#destroy" do
      patch :destroy, params: { id: @event }
      assert_response :ok
    end
  end
end
