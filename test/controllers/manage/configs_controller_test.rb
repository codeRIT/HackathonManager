require "test_helper"

class Manage::ConfigsControllerTest < ActionController::TestCase
  context "while not authenticated" do
    should "redirect to sign in page on manage_configs#index" do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_configs#edit" do
      get :edit, params: { id: "registration_is_open" }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not update config" do
      HackathonConfig["registration_is_open"] = false
      patch :update, params: { id: "registration_is_open", hackathon_config: { registration_is_open: "true" } }
      assert_equal false, HackathonConfig["registration_is_open"]
      assert_redirected_to new_user_session_path
    end

    should "not update css config" do
      HackathonConfig["custom_css"] = ""
      patch :update_only_css_variables, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal "", HackathonConfig["custom_css"]
    end
  end

  context "while authenticated as a user" do
    setup do
      @user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:director]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_configs#index" do
      get :index
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_configs#edit" do
      get :edit, params: { id: "registration_is_open" }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not update config" do
      HackathonConfig["registration_is_open"] = false
      patch :update, params: { id: "registration_is_open", hackathon_config: { registration_is_open: "true" } }
      assert_equal false, HackathonConfig["registration_is_open"]
      assert_redirected_to root_path
    end

    should "not update css config" do
      HackathonConfig["custom_css"] = ""
      patch :update_only_css_variables, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal "", HackathonConfig["custom_css"]
    end
  end

  context "while authenticated as a volunteer" do
    setup do
      @user = create(:volunteer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_configs#index" do
      get :index
      assert_response :unauthorized
    end

    should "not allow access to manage_configs#edit" do
      get :edit, params: { id: "registration_is_open" }
      assert_response :redirect
    end

    should "not update config" do
      HackathonConfig["registration_is_open"] = false
      patch :update, params: { id: "registration_is_open", hackathon_config: { registration_is_open: "true" } }
      assert_equal false, HackathonConfig["registration_is_open"]
    end

    should "not update css config" do
      HackathonConfig["custom_css"] = ""
      patch :update_only_css_variables, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal "", HackathonConfig["custom_css"]
    end
  end

  context "while authenticated as an organizer" do
    setup do
      @user = create(:organizer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_configs#index" do
      get :index
      assert_response :redirect
    end

    should "not allow access to manage_configs#edit" do
      get :edit, params: { id: "registration_is_open" }
      assert_response :redirect
    end

    should "not update config" do
      HackathonConfig["registration_is_open"] = false
      patch :update, params: { id: "registration_is_open", hackathon_config: { registration_is_open: "true" } }
      assert_equal false, HackathonConfig["registration_is_open"]
    end

    should "not update css config" do
      HackathonConfig["custom_css"] = ""
      patch :update_only_css_variables, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal "", HackathonConfig["custom_css"]
    end
  end

  context "while authenticated as a director" do
    setup do
      @user = create(:director)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "allow access to manage_configs#index" do
      get :index
      assert_response :success
    end

    should "allow access to manage_configs#edit" do
      get :edit, params: { id: "registration_is_open" }
      assert_response :success
    end

    should "update config" do
      HackathonConfig["registration_is_open"] = false
      patch :update, params: { id: "registration_is_open", hackathon_config: { registration_is_open: "true" } }
      assert_equal true, HackathonConfig["registration_is_open"]
      assert_redirected_to manage_configs_path
    end

    should "update logo_asset with a url" do
      HackathonConfig["logo_asset"] = ""
      patch :update, params: { id: "logo_asset", hackathon_config: { logo_asset: "https://picsum.photos/200" } }
      assert_equal "https://picsum.photos/200", HackathonConfig["logo_asset"]
      assert_redirected_to manage_configs_path
    end

    should "update config CSS variables when custom_css is blank" do
      HackathonConfig["custom_css"] = ""
      patch :update, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal ":root {\n  --foo: #fff;\n}", HackathonConfig["custom_css"]
    end

    should "update config CSS variables when custom_css contains custom css" do
      HackathonConfig["custom_css"] = ".bar {\n  color: red;\n}"
      patch :update_only_css_variables, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal ":root {\n  --foo: #fff;\n}\n\n.bar {\n  color: red;\n}", HackathonConfig["custom_css"]
    end

    should "update config CSS variables when custom_css contains custom css and existing variables" do
      HackathonConfig["custom_css"] = ".foo {\nabc\n}\n\n:root {\n  --foo: #000;\n}\n\n.bar {\n  color: red;\n}"
      patch :update_only_css_variables, params: { id: "custom_css", hackathon_config: { custom_css: ":root {\n  --foo: #fff;\n}" } }
      assert_equal ".foo {\nabc\n}\n\n:root {\n  --foo: #fff;\n}\n\n.bar {\n  color: red;\n}", HackathonConfig["custom_css"]
    end
  end
end
