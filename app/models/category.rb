# frozen_string_literal: true

# Class Category serves as the Rails model for entity "category" in this blog app
# A category has a many-many atssocation with an article
#  As per https://guides.rubyonrails.org/association_basics.html#the-has-many-association
#
class Category < ApplicationRecord
  has_many  :article_categories
  has_many  :articles, through: :article_categories, dependent: :destroy
  validates :name,  presence: true, uniqueness: true,
                    length: { minimum: 3, maximum: 25 }
end
