require 'test_helper'

class Manage::SchoolsControllerTest < ActionController::TestCase
  setup do
    @school = create(:school)
  end

  context "while not authenticated" do
    should "redirect to sign in page on manage_schools#index" do
      get :index, format: :json
      assert_response :unauthorized
    end

    should "not allow access to manage_schools#show" do
      get :show, params: { id: @school }, format: :json
      assert_response :unauthorized
    end

    should "not allow access to manage_schools#create" do
      post :create, params: { school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, params: { id: @school, school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, params: { id: @school }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#perform_merge" do
      patch :perform_merge, params: { id: @school, school: { id: "My Test School" } }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end
  end

  context "while authenticated as a user" do
    setup do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "not allow access to manage_schools#index" do
      get :index, format: :json
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#show" do
      get :show, params: { id: @school }, format: :json
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#create" do
      post :create, params: { school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, params: { id: @school, school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, params: { id: @school }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#perform_merge" do
      patch :perform_merge, params: { id: @school, school: { id: "My Test School" } }
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

    should "allow access to manage_schools#index" do
      get :index, format: :json
      assert_response :success
    end

    should "allow access to manage_schools#show" do
      get :show, params: { id: @school }, format: :json
      assert_response :success
    end

    should "not allow access to manage_schools#create" do
      post :create, params: { school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, params: { id: @school, school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, params: { id: @school }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#perform_merge" do
      patch :perform_merge, params: { id: @school, school: { id: "My Test School" } }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end
  end

  context "while authenticated as an organizer" do
    setup do
      @user = create(:organizer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "allow access to manage_schools#index" do
      get :index, format: :json
      assert_response :success
    end

    should "allow access to manage_schools#show" do
      get :show, params: { id: @school }, format: :json
      assert_response :success
    end

    should "not allow access to manage_schools#create" do
      post :create, params: { school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, params: { id: @school, school: { name: "My Test School" } }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, params: { id: @school }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#perform_merge" do
      patch :perform_merge, params: { id: @school, school: { id: "My Test School" } }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end
  end

  context "while authenticated as a director" do
    setup do
      @user = create(:director)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "allow access to manage_schools#index" do
      get :index, format: :json
      assert_response :success
    end

    should "not create an school with duplicate names" do
      create(:school, name: "Existing School")
      assert_difference('School.count', 0) do
        post :create, params: { school: { name: "Existing School" } }
      end
    end

    should "allow access to manage_schools#show" do
      get :show, params: { id: @school }, format: :json
      assert_response :ok
    end

    should "update school" do
      patch :update, params: { id: @school, school: { name: "New school name" } }
      assert_response :ok
    end

    should "destroy school" do
      assert_difference('School.count', -1) do
        patch :destroy, params: { id: @school }
      end
      assert_response :ok
    end

    should "not merge into a nonexistent school" do
      ["Nonexistent School"].each do |name|
        assert_difference('School.count', 0) do
          patch :perform_merge, params: { id: @school, school: { id: name } }
        end
      end
    end

    should "not merge into a missing school" do
      assert_difference('School.count', 0) do
        patch :perform_merge, params: { id: @school, school: { id: "" } }
      end
      json = ActiveSupport::JSON.decode response.body
      assert_equal json["error_identifier"], :schools_merge_newSchoolNameMissing.to_s
      assert_response :bad_request
    end

    should "merge schools" do
      new_school = create(:school, name: "Unique School")
      @school.update_attribute(:name, "Unique Sch00l")
      create(:questionnaire, school_id: @school.id, agreements: Agreement.all)
      create(:questionnaire, school_id: @school.id, agreements: Agreement.all)
      create(:questionnaire, school_id: new_school.id, agreements: Agreement.all)
      assert_difference('SchoolNameDuplicate.count', 1) do
        assert_difference('School.count', -1) do
          assert_difference('new_school.reload.questionnaire_count', 2) do
            patch :perform_merge, params: { id: @school, school: { id: "Unique School" } }
          end
        end
      end
      assert_equal new_school.id, SchoolNameDuplicate.where(name: "Unique Sch00l").first.school_id
    end
  end
end
