# frozen_string_literal: true

# Active Record model of comments
class Comment < ApplicationRecord
  belongs_to :article
  validates :content, presence: true
end
