require 'test_helper'

class Manage::TrackableTagsControllerTest < ActionController::TestCase
  setup do
    @trackable_tag = create(:trackable_tag)
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
        end
      end

      # TO-DO: After Devise is converted to API only this needs to be re-added
      # should "not get index" do
      #   test_index_failure
      # end

      should "not create trackable_tag" do
        test_create_failure
      end

      should "not show trackable_tag" do
        test_show_failure
      end

      should "not update trackable_tag" do
        test_update_failure
      end

      should "not destroy trackable_tag" do
        test_destroy_failure
      end
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
      end

      should "get index" do
        test_index_success
      end

      should "not create trackable_tag" do
        test_create_failure
      end

      should "show trackable_tag" do
        test_show_success
      end

      should "not update trackable_tag" do
        test_update_failure
      end

      should "not destroy trackable_tag" do
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

    should "create trackable_tag" do
      test_create_success
    end

    should "show trackable_tag" do
      test_show_success
    end

    should "update trackable_tag" do
      test_update_success
    end

    should "destroy trackable_tag" do
      test_destroy_success
    end
  end

  private

  # index
  def test_index_success
    get :index, format: :json
    assert_response :ok
  end

  def test_index_failure
    get :index, format: :json
    assert_response :unauthorized
  end

  # create
  def test_create_success
    assert_difference('TrackableTag.count') do
      post :create, params: { trackable_tag: { name: build(:trackable_tag).name } }
    end

    assert_response :ok
  end

  def test_create_failure
    assert_difference('TrackableTag.count', 0) do
      post :create, params: { trackable_tag: { name: build(:trackable_tag).name } }
    end

    assert_response :redirect
  end

  # show
  def test_show_success
    get :show, format: :json, params: { id: @trackable_tag.id }
    assert_response :ok
  end

  def test_show_failure
    get :show, params: { id: @trackable_tag.id }
    assert_response :redirect
  end

  # update
  def test_update_success
    new_name = build(:trackable_tag).name
    patch :update, params: { id: @trackable_tag.id, trackable_tag: { name: new_name } }
    assert_equal new_name, @trackable_tag.reload.name
    assert_response :ok
  end

  def test_update_failure
    old_name = @trackable_tag.name
    new_name = build(:trackable_tag).name
    patch :update, params: { id: @trackable_tag.id, trackable_tag: { name: new_name } }
    assert_equal old_name, @trackable_tag.reload.name
    assert_response :redirect
  end

  # destroy
  def test_destroy_success
    assert_difference('TrackableTag.count', -1) do
      delete :destroy, params: { id: @trackable_tag.id }
    end

    assert_response :ok
  end

  def test_destroy_failure
    assert_difference('TrackableTag.count', 0) do
      delete :destroy, params: { id: @trackable_tag.id }
    end

    assert_response :redirect
  end
end
