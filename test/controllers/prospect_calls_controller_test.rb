require 'test_helper'

class ProspectCallsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prospect_call = prospect_calls(:one)
  end

  test "should get index" do
    get prospect_calls_url
    assert_response :success
  end

  test "should get new" do
    get new_prospect_call_url
    assert_response :success
  end

  test "should create prospect_call" do
    assert_difference('ProspectCall.count') do
      post prospect_calls_url, params: { prospect_call: { call_date: @prospect_call.call_date, outcome: @prospect_call.outcome, prospect_id: @prospect_call.prospect_id, who: @prospect_call.who } }
    end

    assert_redirected_to prospect_call_url(ProspectCall.last)
  end

  test "should show prospect_call" do
    get prospect_call_url(@prospect_call)
    assert_response :success
  end

  test "should get edit" do
    get edit_prospect_call_url(@prospect_call)
    assert_response :success
  end

  test "should update prospect_call" do
    patch prospect_call_url(@prospect_call), params: { prospect_call: { call_date: @prospect_call.call_date, outcome: @prospect_call.outcome, prospect_id: @prospect_call.prospect_id, who: @prospect_call.who } }
    assert_redirected_to prospect_call_url(@prospect_call)
  end

  test "should destroy prospect_call" do
    assert_difference('ProspectCall.count', -1) do
      delete prospect_call_url(@prospect_call)
    end

    assert_redirected_to prospect_calls_url
  end
end
