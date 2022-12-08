# frozen_string_literal: true

# Test cases for resource "category"

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # Code in setup is run before every test
  def setup
    @category = Category.new(name: 'Category1')
  end

  test 'category object is valid' do
    assert @category.valid?
  end

  test 'category name is present' do
    @category.name = ''
    assert_not @category.valid?
  end

  test 'category name is unique' do
    @category.save
    @category2 = Category.new(name: 'Category1')
    assert_not @category2.valid?
  end

  test 'category name not too long' do
    @category.name = '12'
    assert_not @category.valid?
  end

  test 'category name not too short' do
    @category.name = '01234567890123456789012345'
    assert_not @category.valid?
  end
end
