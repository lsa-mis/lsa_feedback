class ApplicationController < ActionController::Base
  def index
    render html: "<h1>Test Application</h1><p>This is a test page for the FeedbackGem.</p>".html_safe
  end
end
