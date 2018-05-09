require 'test_helper'

class PlaneBlueprintsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plane_blueprint = plane_blueprints(:one)
  end

  test "should get index" do
    get plane_blueprints_url
    assert_response :success
  end

  test "should get new" do
    get new_plane_blueprint_url
    assert_response :success
  end

  test "should create plane_blueprint" do
    assert_difference('PlaneBlueprint.count') do
      post plane_blueprints_url, params: { plane_blueprint: { seat_map: @plane_blueprint.seat_map } }
    end

    assert_redirected_to plane_blueprint_url(PlaneBlueprint.last)
  end

  test "should show plane_blueprint" do
    get plane_blueprint_url(@plane_blueprint)
    assert_response :success
  end

  test "should get edit" do
    get edit_plane_blueprint_url(@plane_blueprint)
    assert_response :success
  end

  test "should update plane_blueprint" do
    patch plane_blueprint_url(@plane_blueprint), params: { plane_blueprint: { seat_map: @plane_blueprint.seat_map } }
    assert_redirected_to plane_blueprint_url(@plane_blueprint)
  end

  test "should destroy plane_blueprint" do
    assert_difference('PlaneBlueprint.count', -1) do
      delete plane_blueprint_url(@plane_blueprint)
    end

    assert_redirected_to plane_blueprints_url
  end
end
