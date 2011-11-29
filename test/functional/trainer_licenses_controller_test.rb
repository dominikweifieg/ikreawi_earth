require 'test_helper'

class TrainerLicensesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trainer_licenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trainer_license" do
    assert_difference('TrainerLicense.count') do
      post :create, :trainer_license => { }
    end

    assert_redirected_to trainer_license_path(assigns(:trainer_license))
  end

  test "should show trainer_license" do
    get :show, :id => trainer_licenses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => trainer_licenses(:one).to_param
    assert_response :success
  end

  test "should update trainer_license" do
    put :update, :id => trainer_licenses(:one).to_param, :trainer_license => { }
    assert_redirected_to trainer_license_path(assigns(:trainer_license))
  end

  test "should destroy trainer_license" do
    assert_difference('TrainerLicense.count', -1) do
      delete :destroy, :id => trainer_licenses(:one).to_param
    end

    assert_redirected_to trainer_licenses_path
  end
end
