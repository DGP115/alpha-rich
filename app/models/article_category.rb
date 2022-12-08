# frozen_string_literal: true

# Class articlecategory serves as the Rails model for the many-many assocation
# between articles and categories in this blog app
#
class ArticleCategory < ApplicationRecord
  belongs_to :article
  belongs_to :category
end
