# frozen_string_literal: true

require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'johndoe', email_address: 'admin@admin.com',
                              password: 'admin_password', admin: true)
    sign_in_as(@admin_user)
  end

  test 'get new category form and create category' do
    get '/categories/new'
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Category2' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Category2', @response.body
  end

  test 'get new category form and reject blank category submission' do
    get '/categories/new'
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: '' } }
    end
    assert_match 'error(s)', @response.body # assert_match looks for content in html.body
    assert_select 'h6.alert-heading' # asset_select looks at html code vs displayed text
  end

  test 'get new category form and reject repeated category submission' do
    get '/categories/new'
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Category2' } }
    end
    get '/categories/new'
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: 'Category2' } }
    end
    assert_match 'error(s)', @response.body # assert_match looks for content in html.body
    assert_select 'h6.alert-heading' # asset_select looks at html code vs displayed text
  end
end
