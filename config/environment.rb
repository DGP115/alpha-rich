# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# This is here to stop Rails from creating html format issues when error messages are displayed.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
