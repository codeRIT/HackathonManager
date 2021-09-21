require 'test_helper'

class BusListsControllerTest < ActionController::TestCase
  setup do
    @questionnaire = create(:questionnaire)
  end

  context "while not authenticated" do
    should "redirect to sign in page on bus_list#show" do
      get :show
      assert_redirected_to new_user_session_path
    end

    should "redirect to sign in page on bus_list#boarded_bus" do
      patch :boarded_bus
      assert_redirected_to new_user_session_path
    end
  end

  context "while authenticated without a questionnaire" do
    setup do
      @request.env["devise.mapping"] = Devise.mappings[:director]
      @user = create(:user, email: "newabc@example.com")
      sign_in @user
      @request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "return not found on bus_list#show" do
      get :show
      assert_response :not_found
    end

    should "return not found on bus_list#boarded_bus" do
      patch :boarded_bus
      assert_response :not_found
    end
  end

  context "while authenticated with a questionnaire but no bus list" do
    setup do
      @request.env["devise.mapping"] = Devise.mappings[:director]
      sign_in @questionnaire.user
      @request.headers["Authorization"] = "Bearer " + @questionnaire.user.generate_jwt
      @questionnaire.update_attribute(:acc_status, "accepted")
    end

    should "redirect to root page on bus_list#show" do
      get :show
      assert_response :not_found
    end

    should "redirect to root page on bus_list#boarded_bus" do
      patch :boarded_bus
      assert_response :not_found
    end
  end

  context "while authenticated with a questionnaire with a bus list" do
    setup do
      @request.env["devise.mapping"] = Devise.mappings[:director]
      sign_in @questionnaire.user
      @request.headers["Authorization"] = "Bearer " + @questionnaire.user.generate_jwt
      @questionnaire.update_attribute(:acc_status, "accepted")
      @bus_list = create(:bus_list)
      @questionnaire.update_attribute(:bus_list_id, @bus_list.id)
    end

    context "but is not bus captain" do
      should "return unauthorized on bus_list#show" do
        get :show
        assert_response :unauthorized
      end

      should "return unauthorized on bus_list#boarded_bus" do
        patch :boarded_bus
        assert_response :unauthorized
      end
    end

    context "and is bus captain" do
      setup do
        @questionnaire.update_attribute(:is_bus_captain, true)
      end

      should "render bus_list#show" do
        get :show, format: :json
        assert_response :success
      end

      should "allow bus_list#boarded_bus - checking in self" do
        patch :boarded_bus, params: { questionnaire: { id: @questionnaire.id, boarded_bus: true } }
        assert_response :success
        assert_not_nil @questionnaire.reload.boarded_bus_at
      end

      should "allow bus_list#boarded_bus - checking out self" do
        @questionnaire.update_attribute(:boarded_bus_at, Time.now)
        patch :boarded_bus, params: { questionnaire: { id: @questionnaire.id, boarded_bus: false } }
        assert_response :success
        assert_nil @questionnaire.reload.boarded_bus_at
      end

      should "not allow bus_list#boarded_bus for questionnaire not riding this bus" do
        bus_list = create(:bus_list, name: "A random bus list")
        questionnaire = create(:questionnaire, acc_status: 'rsvp_confirmed', bus_list_id: bus_list.id, agreements: Agreement.all)
        patch :boarded_bus, params: { questionnaire: { id: questionnaire.id, boarded_bus: true } }
        assert_response :bad_request
        assert_nil questionnaire.reload.boarded_bus_at
      end
    end
  end
end
