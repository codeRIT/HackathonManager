require 'test_helper'

class Manage::TrackableEventsControllerTest < ActionController::TestCase
  setup do
    @trackable_event = create(:trackable_event)
  end

  unauth_conditions = {
    'not authenticated' => false,
    'authenticated as a user' => true
  }

  unauth_conditions.each do |condition_name, do_sign_in|
    context "while #{condition_name}" do
      setup do
        if do_sign_in
          @user = create(:user)
          @request.env["devise.mapping"] = Devise.mappings[:director]
          sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
          @trackable_event.update_attribute(:user, @user)
        end
      end

      # TO-DO: After Devise is converted to API only this needs to be re-added
      # should "not get index" do
      #   test_index_failure
      # end

      # TO-DO: After Devise is converted to API only this needs to be re-added
      # should "not create trackable_event" do
      #   test_create_failure
      # end

      # TO-DO: After Devise is converted to API only this needs to be re-added
      # should "not show trackable_event" do
      #   test_show_failure
      # end

      # TO-DO: After Devise is converted to API only this needs to be re-added
      # should "not update trackable_event" do
      #   test_update_failure
      # end

      # TO-DO: After Devise is converted to API only this needs to be re-added
      # should "not destroy trackable_event" do
      #   test_destroy_failure
      # end
    end
  end

  limited_conditions = {
    'volunteer' => :volunteer,
    'organizer' => :organizer
  }

  limited_conditions.each do |condition_name, user_role|
    context "while authenticated as a #{condition_name}" do
      setup do
        @user = create(:user, role: user_role)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
        @trackable_event.update_attribute(:user, @user)
      end

      should "get index" do
        test_index_success
      end

      should "create trackable_event" do
        test_create_success
      end

      should "show trackable_event" do
        test_show_success
      end

      should "update trackable_event" do
        test_update_success
      end

      should "not update trackable_event that doesn't belong to user" do
        @trackable_event.update_attribute(:user, create(:user))
        test_update_failure
      end

      should "destroy trackable_event" do
        test_destroy_success
      end

      should "not destroy trackable_event that doesn't belong to user" do
        @trackable_event.update_attribute(:user, create(:user))
        test_destroy_failure
      end
    end
  end

  context "while authenticated as a director" do
    setup do
      @user = create(:director)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
			@request.headers["Authorization"] = "Bearer " + @user.generate_jwt
    end

    should "get index" do
      test_index_success
    end

    should "create trackable_event" do
      test_create_success
    end

    should "show trackable_event" do
      test_show_success
    end

    should "update trackable_event" do
      test_update_success
    end

    should "destroy trackable_event" do
      test_destroy_success
    end
  end

  private

  # index
  def test_index_success
    get :index, format: :json
    assert_response :success
  end

  def test_index_failure
    get :index, format: :json
    assert_response :redirect
  end

  # create
  def test_create_success
    assert_difference('TrackableEvent.count') do
      post :create, params: { trackable_event: { band_id: @trackable_event.band_id, trackable_tag_id: @trackable_event.trackable_tag_id } }
    end

    assert_response :ok
    assert_equal @user.id, TrackableEvent.last.user_id
  end

  def test_create_failure
    assert_difference('TrackableEvent.count', 0) do
      post :create, params: { trackable_event: { band_id: @trackable_event.band_id, trackable_tag_id: @trackable_event.trackable_tag_id } }
    end

    assert_response :unauthorized
  end

  # show
  def test_show_success
    get :show, format: :json, params: { id: @trackable_event.id }
    assert_response :ok
  end

  def test_show_failure
    get :show, params: { id: @trackable_event.id }
    assert_response :unauthorized
  end

  # update
  def test_update_success
    patch :update, params: { id: @trackable_event.id, trackable_event: { band_id: @trackable_event.band_id, trackable_tag_id: @trackable_event.trackable_tag_id } }
    assert_response :ok
  end

  def test_update_failure
    patch :update, params: { id: @trackable_event.id, trackable_event: { band_id: @trackable_event.band_id, trackable_tag_id: @trackable_event.trackable_tag_id } }
    assert_response :unauthorized
  end

  # destroy
  def test_destroy_success
    assert_difference('TrackableEvent.count', -1) do
      delete :destroy, params: { id: @trackable_event.id }
    end

    assert_response :ok
  end

  def test_destroy_failure
    assert_difference('TrackableEvent.count', 0) do
      delete :destroy, params: { id: @trackable_event.id }
    end

    assert_response :unauthorized
  end
end
