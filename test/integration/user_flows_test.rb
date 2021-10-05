require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest

  should "be able to login and browse site as a director" do
    login(FactoryBot.create(:director))
    assert_redirected_to new_questionnaires_path

    get manage_questionnaires_path(format: :json)
    assert_response :success
  end

  should "redirect to previously-attempted page after login" do
    get manage_questionnaires_path
    assert_response :redirect

    login(FactoryBot.create(:director))
    assert_redirected_to manage_questionnaires_path
  end

  should "redirect to completed application after login" do
    questionnaire = FactoryBot.create(:questionnaire)
    login(questionnaire.user)
    assert_redirected_to questionnaires_path
  end

  private

  def login(user)
    post user_session_url, params: { user: { email: user.email, password: user.password } }
    assert_equal 'Signed in successfully.', flash[:notice]
  end
end
