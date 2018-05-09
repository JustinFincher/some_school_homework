require 'test_helper'

class BackstagePropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @backstage_prop = backstage_props(:one)
  end

  test "should get index" do
    get backstage_props_url
    assert_response :success
  end

  test "should get new" do
    get new_backstage_prop_url
    assert_response :success
  end

  test "should create backstage_prop" do
    assert_difference('BackstageProp.count') do
      post backstage_props_url, params: { backstage_prop: {  } }
    end

    assert_redirected_to backstage_prop_url(BackstageProp.last)
  end

  test "should show backstage_prop" do
    get backstage_prop_url(@backstage_prop)
    assert_response :success
  end

  test "should get edit" do
    get edit_backstage_prop_url(@backstage_prop)
    assert_response :success
  end

  test "should update backstage_prop" do
    patch backstage_prop_url(@backstage_prop), params: { backstage_prop: {  } }
    assert_redirected_to backstage_prop_url(@backstage_prop)
  end

  test "should destroy backstage_prop" do
    assert_difference('BackstageProp.count', -1) do
      delete backstage_prop_url(@backstage_prop)
    end

    assert_redirected_to backstage_props_url
  end
end
