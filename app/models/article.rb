# frozen_string_literal: true

# Class article serves as the Rails model for entity "article" in this blog app
#
class Article < ApplicationRecord
  # This bare-bones model for resource article can simply be an empty inheritance
  # from ApplicationRecord
  # Recall that all the getter, setter methods we need are already provided by the
  # inheritance from Application Record

  #  BUT: note that, by default, this model does not include any constraints - known as validations
  #  in Rails.  So they must be added here.

  #  Validations (i.e. Constraints).
  #   NOTE:  Validations work at the object model level, not the database.
  #   Add a validation that article attribute "title" must have a value (when it is saved)
  #   and length limits as shown.
  #   Do the same for article attribute "description"
  belongs_to :user
  has_many  :article_categories
  has_many  :comments, dependent: :destroy
  has_many  :categories, through: :article_categories, dependent: :destroy
  has_rich_text :content
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }
  #  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
  validates :content, presence: true
end
