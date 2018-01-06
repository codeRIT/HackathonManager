require 'test_helper'

class Manage::ConfigsControllerTest < ActionController::TestCase
  context "while not authenticated" do
    should "redirect to sign in page on manage_configs#show" do
      get :show
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end
  end

  context "while authenticated as a user" do
    setup do
      @user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in @user
    end

    should "not allow access to manage_configs#show" do
      get :show
      assert_response :redirect
      assert_redirected_to root_path
    end
  end

  context "while authenticated as a limited access admin" do
    setup do
      @user = create(:limited_access_admin)
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in @user
    end

    should "not allow access to manage_configs#show" do
      get :show
      assert_response :redirect
      assert_redirected_to manage_root_path
    end
  end

  context "while authenticated as an admin" do
    setup do
      @user = create(:admin)
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in @user
    end

    should "allow access to manage_configs#show" do
      get :show
      assert_response :success
    end
  end
end
