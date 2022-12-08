# frozen_string_literal: true

# Class User serves as the Rails model for entity "user" in this blog app
class User < ApplicationRecord
  before_save { self.email_address = email_address.downcase }
  has_many :articles, dependent: :destroy
  validates :username,  presence: true, uniqueness: { case_sensitive: false },
                        length: { minimum: 3, maximum: 25 }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false },
                            email: { mode: :strict, require_fqdn: true },
                            length: { maximum: 105 }
  has_secure_password
end
